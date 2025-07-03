package com.example.booksexchange

import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

class NativeAdFactoryExample(private val layoutInflater: LayoutInflater) : NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val adView = layoutInflater.inflate(R.layout.my_native_ad, null) as NativeAdView

        adView.mediaView = adView.findViewById(R.id.ad_media)
        adView.headlineView = adView.findViewById(R.id.ad_headline)
        adView.bodyView = adView.findViewById(R.id.ad_body)
        adView.callToActionView = adView.findViewById(R.id.ad_call_to_action)
        adView.iconView = adView.findViewById(R.id.ad_app_icon)
        adView.priceView = adView.findViewById(R.id.ad_price)
        adView.starRatingView = adView.findViewById(R.id.ad_stars)
        adView.storeView = adView.findViewById(R.id.ad_store)
        adView.advertiserView = adView.findViewById(R.id.ad_advertiser)

        // Always present (non-null)
        (adView.headlineView as TextView).text = nativeAd.headline
        (adView.bodyView as TextView).text = nativeAd.body
        (adView.callToActionView as Button).text = nativeAd.callToAction
        adView.mediaView?.mediaContent = nativeAd.mediaContent

        // Nullable checks
        nativeAd.icon?.let {
            (adView.iconView as ImageView).setImageDrawable(it.drawable)
            adView.iconView?.visibility = View.VISIBLE
        } ?: run {
            adView.iconView?.visibility = View.GONE
        }

        nativeAd.price?.let {
            (adView.priceView as TextView).text = it
            adView.priceView?.visibility = View.VISIBLE
        } ?: run {
            adView.priceView?.visibility = View.INVISIBLE
        }

        nativeAd.store?.let {
            (adView.storeView as TextView).text = it
            adView.storeView?.visibility = View.VISIBLE
        } ?: run {
            adView.storeView?.visibility = View.INVISIBLE
        }

        nativeAd.starRating?.let {
            (adView.starRatingView as RatingBar).rating = it.toFloat()
            adView.starRatingView?.visibility = View.VISIBLE
        } ?: run {
            adView.starRatingView?.visibility = View.INVISIBLE
        }

        nativeAd.advertiser?.let {
            (adView.advertiserView as TextView).text = it
            adView.advertiserView?.visibility = View.VISIBLE
        } ?: run {
            adView.advertiserView?.visibility = View.INVISIBLE
        }

        adView.setNativeAd(nativeAd)
        return adView
    }
}
