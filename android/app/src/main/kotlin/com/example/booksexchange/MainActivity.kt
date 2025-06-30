package com.example.booksexchange

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.StrictMode
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.tensorflow.lite.Interpreter
import java.nio.ByteBuffer
import java.nio.ByteOrder
import com.google.firebase.ml.modeldownloader.CustomModel
import com.google.firebase.ml.modeldownloader.CustomModelDownloadConditions
import com.google.firebase.ml.modeldownloader.FirebaseModelDownloader
import com.google.firebase.ml.modeldownloader.DownloadType

class MainActivity : FlutterActivity() {

    private val NETWORK_CHANNEL = "com.example.network/check"
    private val TFLITE_CHANNEL = "com.example.tflite/inference"

    private lateinit var tfliteInterpreter: Interpreter
    private lateinit var inputShape: IntArray
    private val labels = List(80) { "Class $it" }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NETWORK_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getNetworkStatus") {
                    val status = getNetworkStatus()
                    result.success(status)
                } else {
                    result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, TFLITE_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "runModel") {
                    val imagePath = call.argument<String>("imagePath") ?: ""
                    try {
                        val bitmap = BitmapFactory.decodeFile(imagePath)
                        val (className, confidence) = runModelInference(bitmap)
                            ?: return@setMethodCallHandler result.error("ERR", "No result", null)

                        result.success(mapOf("class" to className, "confidence" to confidence))
                    } catch (e: Exception) {
                        result.error("ERR", "Inference failed: ${e.message}", null)
                    }
                } else {
                    result.notImplemented()
                }
            }

        initModel()
    }

    private fun initModel() {
        val conditions = CustomModelDownloadConditions.Builder()
            .requireWifi()
            .build()

        FirebaseModelDownloader.getInstance()
            .getModel("book-detector", DownloadType.LOCAL_MODEL, conditions)
            .addOnSuccessListener { model: CustomModel ->
                try {
                    val modelFile = model.file!!
                    tfliteInterpreter = Interpreter(modelFile)
                    inputShape = tfliteInterpreter.getInputTensor(0).shape()

                    Log.d("TFLite", "Model initialized from Firebase ML successfully.")
                } catch (e: Exception) {
                    Log.e("TFLite", "Error initializing model: ${e.message}")
                }
            }
            .addOnFailureListener {
                Log.e("TFLite", "Failed to download model: ${it.message}")
            }
    }

    private fun runModelInference(bitmap: Bitmap): Pair<String, Float>? {
        val inputBuffer = preprocessImage(bitmap)

        val outputShape = tfliteInterpreter.getOutputTensor(0).shape()
        val outputData = Array(1) { Array(outputShape[1]) { FloatArray(outputShape[2]) } }

        tfliteInterpreter.run(inputBuffer, outputData)

        val transposed = Array(1) { Array(outputShape[2]) { FloatArray(outputShape[1]) } }
        for (i in 0 until outputShape[1]) {
            for (j in 0 until outputShape[2]) {
                transposed[0][j][i] = outputData[0][i][j]
            }
        }

        val scores: List<FloatArray> = transposed[0].map { it.copyOfRange(4, it.size) }
        val flat: List<Float> = scores.flatMap { it.toList() }

        if (flat.isEmpty()) return null

        val maxIndex = flat.indices.maxByOrNull { flat[it] } ?: return null
        val confidence = flat[maxIndex]
        val classId = maxIndex % labels.size
        val className = labels[classId]

        return Pair(className, confidence)
    }

    private fun preprocessImage(bitmap: Bitmap): ByteBuffer {
        val height = inputShape[1]
        val width = inputShape[2]
        val resized = Bitmap.createScaledBitmap(bitmap, width, height, true)

        val buffer = ByteBuffer.allocateDirect(4 * width * height * 3)
        buffer.order(ByteOrder.nativeOrder())

        for (y in 0 until height) {
            for (x in 0 until width) {
                val pixel = resized.getPixel(x, y)
                buffer.putFloat((pixel shr 16 and 0xFF) / 255.0f) // R
                buffer.putFloat((pixel shr 8 and 0xFF) / 255.0f)  // G
                buffer.putFloat((pixel and 0xFF) / 255.0f)        // B
            }
        }

        buffer.rewind()
        return buffer
    }

    private fun getNetworkStatus(): String {
        val connectivityManager = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val network = connectivityManager.activeNetwork
        val capabilities = network?.let { connectivityManager.getNetworkCapabilities(it) }

        val isConnected = capabilities != null &&
                (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)
                        || capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR))

        val hasInternet = if (isConnected) hasInternetAccess() else false

        return when {
            !isConnected -> "none"
            capabilities!!.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) && hasInternet -> "wifi_internet"
            capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> "wifi_no_internet"
            capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) && hasInternet -> "mobile_internet"
            capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> "mobile_no_internet"
            else -> "unknown"
        }
    }

    private fun hasInternetAccess(): Boolean {
        return try {
            val policy = StrictMode.ThreadPolicy.Builder().permitAll().build()
            StrictMode.setThreadPolicy(policy)

            val url = java.net.URL("https://clients3.google.com/generate_204")
            val connection = url.openConnection() as java.net.HttpURLConnection
            connection.setRequestProperty("User-Agent", "Android")
            connection.setRequestProperty("Connection", "close")
            connection.connectTimeout = 500
            connection.readTimeout = 500
            connection.connect()

            connection.responseCode == 204
        } catch (e: Exception) {
            false
        }
    }
}
