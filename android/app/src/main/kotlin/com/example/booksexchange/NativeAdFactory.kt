package com.example.booksexchange

import android.view.LayoutInflater
import android.view.View
import android.widget.*
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

class NativeAdFactoryExample(private val layoutInflater: LayoutInflater) : NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val adView = layoutInflater.inflate(R.layout.my_native_ad, null) as NativeAdView

        adView.headlineView = adView.findViewById(R.id.primary)
        adView.bodyView = adView.findViewById(R.id.secondary)
        adView.callToActionView = adView.findViewById(R.id.cta)
        adView.iconView = adView.findViewById(R.id.icon)
        adView.starRatingView = adView.findViewById(R.id.rating_bar)
        adView.advertiserView = adView.findViewById(R.id.ad_notification_view)

        // Required views
        (adView.headlineView as TextView).text = nativeAd.headline
        (adView.bodyView as TextView).text = nativeAd.body
        (adView.callToActionView as Button).text = nativeAd.callToAction

        // Optional views with safe checks
        nativeAd.icon?.let {
            (adView.iconView as ImageView).setImageDrawable(it.drawable)
            adView.iconView?.visibility = View.VISIBLE
        } ?: run {
            adView.iconView?.visibility = View.GONE
        }

        nativeAd.starRating?.let {
            (adView.starRatingView as RatingBar).rating = it.toFloat()
            adView.starRatingView?.visibility = View.VISIBLE
        } ?: run {
            adView.starRatingView?.visibility = View.GONE
        }

        nativeAd.advertiser?.let {
            (adView.advertiserView as TextView).text = "Ad • $it"
            adView.advertiserView?.visibility = View.VISIBLE
        } ?: run {
            adView.advertiserView?.visibility = View.GONE
        }

        adView.setNativeAd(nativeAd)
        return adView
    }
}