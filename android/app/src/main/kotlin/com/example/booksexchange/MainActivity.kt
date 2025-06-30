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
import java.io.File
import java.nio.channels.FileChannel
import java.io.FileInputStream

// Firebase ML dependencies
import com.google.firebase.ml.modeldownloader.FirebaseModelDownloader
import com.google.firebase.ml.modeldownloader.CustomModelDownloadConditions
import com.google.firebase.ml.modeldownloader.DownloadType
import com.google.firebase.ml.modeldownloader.CustomModel

class MainActivity : FlutterActivity() {

    data class Detection(
        val confidence: Float,
        val x: Float,
        val y: Float,
        val w: Float,
        val h: Float
    )

    private fun parseModelOutput(
        output: Array<Array<FloatArray>>,
        classIndex: Int,
        threshold: Float
    ): Detection? {
        val detections = output[0]
        var bestScore = 0f
        var bestDetection: Detection? = null

        for (i in 0 until detections[0].size) {
            val x = output[0][0][i]
            val y = output[0][1][i]
            val w = output[0][2][i]
            val h = output[0][3][i]
            val objectConfidence = output[0][4][i]
            val classConfidence = output[0][5 + classIndex][i]
            val confidence = objectConfidence * classConfidence

            if (confidence > threshold && confidence > bestScore) {
                bestScore = confidence
                bestDetection = Detection(confidence, x, y, w, h)
            }
        }

        return bestDetection
    }

    private val NETWORK_CHANNEL = "com.example.network/check"
    private val DETECTION_CHANNEL = "book_detector"
    private var interpreter: Interpreter? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // 1. Set up network status channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NETWORK_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getNetworkStatus") {
                    val status = getNetworkStatus()
                    result.success(status)
                } else {
                    result.notImplemented()
                }
            }

        // 2. Load TFLite model from Firebase and then set up detection channel
        FirebaseModelDownloader.getInstance()
            .getModel(
                "book-detector",
                DownloadType.LOCAL_MODEL_UPDATE_IN_BACKGROUND,
                CustomModelDownloadConditions.Builder().build()
            )
            .addOnSuccessListener { model: CustomModel? ->
                val file = model?.file
                if (file != null && file.exists()) {
                    interpreter = Interpreter(file)

                    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DETECTION_CHANNEL)
                        .setMethodCallHandler { call, result ->
                            if (call.method == "detectBook") {
                                val imageBytes = call.argument<ByteArray>("image")!!
                                val bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)

                                val prediction = runBookModel(bitmap)
                                result.success(prediction)
                            } else {
                                result.notImplemented()
                            }
                        }

                    Log.i("BookModel", "Model loaded successfully from Firebase")
                } else {
                    Log.e("BookModel", "Model file was null or missing")
                }
            }
            .addOnFailureListener { e ->
                Log.e("BookModel", "Failed to load model: ${e.message}")
            }
    }

    private fun runBookModel(bitmap: Bitmap): Boolean {
        val input = preprocessBitmap(bitmap)
        val output = Array(1) { Array(8) { FloatArray(8400) } }

        interpreter?.run(input as Any, output as Any)

        val bestDetection = parseModelOutput(output, classIndex = 0, threshold = 0.02f)
        return bestDetection != null
    }

    private fun preprocessBitmap(bitmap: Bitmap): ByteBuffer {
       // Log.d("BufferSize", "Capacity: ${inputBuffer.capacity()}, Expected: ${4 * 640 * 640 * 3}")
        val inputWidth = 640
        val inputHeight = 640
        val inputChannels = 3

        val resized = Bitmap.createScaledBitmap(bitmap, inputWidth, inputHeight, true)

        val inputBuffer = ByteBuffer.allocateDirect(4 * inputWidth * inputHeight * inputChannels)
        inputBuffer.order(ByteOrder.nativeOrder())

        val pixels = IntArray(inputWidth * inputHeight)
        resized.getPixels(pixels, 0, inputWidth, 0, 0, inputWidth, inputHeight)

        // Write in HWC format: [height][width][channels]
        for (y in 0 until inputHeight) {
            for (x in 0 until inputWidth) {
                val pixel = pixels[y * inputWidth + x]
                val r = ((pixel shr 16) and 0xFF) / 255.0f
                val g = ((pixel shr 8) and 0xFF) / 255.0f
                val b = (pixel and 0xFF) / 255.0f
                inputBuffer.putFloat(r)
                inputBuffer.putFloat(g)
                inputBuffer.putFloat(b)
            }
        }

        inputBuffer.rewind()
        return inputBuffer
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