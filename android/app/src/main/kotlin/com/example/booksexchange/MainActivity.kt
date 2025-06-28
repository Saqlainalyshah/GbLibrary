package com.example.booksexchange

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.StrictMode
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.network/check"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getNetworkStatus") {
                    val connectivityManager = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
                    val network = connectivityManager.activeNetwork
                    val capabilities = network?.let { connectivityManager.getNetworkCapabilities(it) }

                    val isConnected = capabilities != null &&
                            (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)
                                    || capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR))

                    val hasInternet = if (isConnected) {
                        hasInternetAccess()
                    } else false

                    val response = when {
                        !isConnected -> "none"
                        capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) && hasInternet -> "wifi_internet"
                        capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> "wifi_no_internet"
                        capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) && hasInternet -> "mobile_internet"
                        capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> "mobile_no_internet"
                        else -> "unknown"
                    }

                    result.success(response)
                } else {
                    result.notImplemented()
                }
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
