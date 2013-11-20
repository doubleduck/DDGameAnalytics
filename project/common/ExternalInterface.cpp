#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "ga.h"


using namespace ddgameanalytics;

#ifdef IPHONE

value ga_init(value id, value secret, value version)
{
    gaInit(val_string(id), val_string(secret), val_string(version));
    return alloc_null();
}
DEFINE_PRIM(ga_init, 3);

value ga_design_event(value id, value eventValue, value area)
{
    gaDesignEvent(val_string(id), val_float(eventValue), val_string(area));
    return alloc_null();
}
DEFINE_PRIM(ga_design_event, 3);

value ga_business_event(value id, value currency, value amount, value area)
{
    gaBusinessEvent(val_string(id), val_string(currency), val_int(amount), val_string(area));
    return alloc_null();
}
DEFINE_PRIM(ga_business_event, 4);

#endif


extern "C" void ddgameanalytics_main () {
	
	val_int(0); // Fix Neko init
	
}
DEFINE_ENTRY_POINT (ddgameanalytics_main);



extern "C" int ddgameanalytics_register_prims () { return 0; }