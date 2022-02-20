#ifdef ANDROID
URLProtocol ff_android_protocol;
#endif

static const URLProtocol *url_protocols[] = {
#ifdef ANDROID
    &ff_android_protocol,
#endif
    NULL };
