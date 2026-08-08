// Lean compiler output
// Module: Siegel.SiegelZeroFree
// Imports: Init Mathlib.Analysis.SpecialFunctions.Log.Basic Mathlib.Data.Real.Basic
#include <lean/lean.h>
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wunused-parameter"
#pragma clang diagnostic ignored "-Wunused-label"
#elif defined(__GNUC__) && !defined(__CLANG__)
#pragma GCC diagnostic ignored "-Wunused-parameter"
#pragma GCC diagnostic ignored "-Wunused-label"
#pragma GCC diagnostic ignored "-Wunused-but-set-variable"
#endif
#ifdef __cplusplus
extern "C" {
#endif
static lean_object* l_Siegel_Siegel__certificate___closed__6;
static lean_object* l_Siegel_Siegel__certificate___closed__3;
static lean_object* l_Siegel_Siegel__certificate___closed__11;
static lean_object* l_Siegel_Siegel__certificate___closed__10;
static lean_object* l_Siegel_Siegel__certificate___closed__8;
static lean_object* l_Siegel_Siegel__certificate___closed__9;
static lean_object* l_Siegel_Siegel__certificate___closed__4;
static lean_object* l_Siegel_Siegel__certificate___closed__2;
static lean_object* l_Siegel_Siegel__certificate___closed__7;
LEAN_EXPORT lean_object* l_Siegel_Siegel__certificate;
lean_object* lean_string_append(lean_object*, lean_object*);
static lean_object* l_Siegel_Siegel__certificate___closed__5;
static lean_object* l_Siegel_Siegel__certificate___closed__1;
static lean_object* _init_l_Siegel_Siegel__certificate___closed__1() {
_start:
{
lean_object* x_1; 
x_1 = lean_mk_string_unchecked("SIEGEL Deuring-Heilbronn-Siegel zero repulsion at p5 = 3993746143633\n", 69, 69);
return x_1;
}
}
static lean_object* _init_l_Siegel_Siegel__certificate___closed__2() {
_start:
{
lean_object* x_1; 
x_1 = lean_mk_string_unchecked("D_eff = 0.5235 < repulsion_bound = 1.3057  [Siegel_D_eff_lt_bound, 0 sorry]\n", 76, 76);
return x_1;
}
}
static lean_object* _init_l_Siegel_Siegel__certificate___closed__3() {
_start:
{
lean_object* x_1; lean_object* x_2; lean_object* x_3; 
x_1 = l_Siegel_Siegel__certificate___closed__1;
x_2 = l_Siegel_Siegel__certificate___closed__2;
x_3 = lean_string_append(x_1, x_2);
return x_3;
}
}
static lean_object* _init_l_Siegel_Siegel__certificate___closed__4() {
_start:
{
lean_object* x_1; 
x_1 = lean_mk_string_unchecked("c1    = 0.209  > threshold = 0.2           [Siegel_c1_exceeds_threshold, 0 sorry]\n", 82, 82);
return x_1;
}
}
static lean_object* _init_l_Siegel_Siegel__certificate___closed__5() {
_start:
{
lean_object* x_1; lean_object* x_2; lean_object* x_3; 
x_1 = l_Siegel_Siegel__certificate___closed__3;
x_2 = l_Siegel_Siegel__certificate___closed__4;
x_3 = lean_string_append(x_1, x_2);
return x_3;
}
}
static lean_object* _init_l_Siegel_Siegel__certificate___closed__6() {
_start:
{
lean_object* x_1; 
x_1 = lean_mk_string_unchecked("ratio = 1.045  > 1                         [Siegel_ratio_positive, 0 sorry]\n", 76, 76);
return x_1;
}
}
static lean_object* _init_l_Siegel_Siegel__certificate___closed__7() {
_start:
{
lean_object* x_1; lean_object* x_2; lean_object* x_3; 
x_1 = l_Siegel_Siegel__certificate___closed__5;
x_2 = l_Siegel_Siegel__certificate___closed__6;
x_3 = lean_string_append(x_1, x_2);
return x_3;
}
}
static lean_object* _init_l_Siegel_Siegel__certificate___closed__8() {
_start:
{
lean_object* x_1; 
x_1 = lean_mk_string_unchecked("Conclusion: no L-function zero beta > 0.9  [Siegel_ZeroFreeRegion_p5, SORRY: repulsion]\n", 88, 88);
return x_1;
}
}
static lean_object* _init_l_Siegel_Siegel__certificate___closed__9() {
_start:
{
lean_object* x_1; lean_object* x_2; lean_object* x_3; 
x_1 = l_Siegel_Siegel__certificate___closed__7;
x_2 = l_Siegel_Siegel__certificate___closed__8;
x_3 = lean_string_append(x_1, x_2);
return x_3;
}
}
static lean_object* _init_l_Siegel_Siegel__certificate___closed__10() {
_start:
{
lean_object* x_1; 
x_1 = lean_mk_string_unchecked("Named Siegel.  Very proudly.", 28, 28);
return x_1;
}
}
static lean_object* _init_l_Siegel_Siegel__certificate___closed__11() {
_start:
{
lean_object* x_1; lean_object* x_2; lean_object* x_3; 
x_1 = l_Siegel_Siegel__certificate___closed__9;
x_2 = l_Siegel_Siegel__certificate___closed__10;
x_3 = lean_string_append(x_1, x_2);
return x_3;
}
}
static lean_object* _init_l_Siegel_Siegel__certificate() {
_start:
{
lean_object* x_1; 
x_1 = l_Siegel_Siegel__certificate___closed__11;
return x_1;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_Mathlib_Analysis_SpecialFunctions_Log_Basic(uint8_t builtin, lean_object*);
lean_object* initialize_Mathlib_Data_Real_Basic(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_Siegel_SiegelZeroFree(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Mathlib_Analysis_SpecialFunctions_Log_Basic(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Mathlib_Data_Real_Basic(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
l_Siegel_Siegel__certificate___closed__1 = _init_l_Siegel_Siegel__certificate___closed__1();
lean_mark_persistent(l_Siegel_Siegel__certificate___closed__1);
l_Siegel_Siegel__certificate___closed__2 = _init_l_Siegel_Siegel__certificate___closed__2();
lean_mark_persistent(l_Siegel_Siegel__certificate___closed__2);
l_Siegel_Siegel__certificate___closed__3 = _init_l_Siegel_Siegel__certificate___closed__3();
lean_mark_persistent(l_Siegel_Siegel__certificate___closed__3);
l_Siegel_Siegel__certificate___closed__4 = _init_l_Siegel_Siegel__certificate___closed__4();
lean_mark_persistent(l_Siegel_Siegel__certificate___closed__4);
l_Siegel_Siegel__certificate___closed__5 = _init_l_Siegel_Siegel__certificate___closed__5();
lean_mark_persistent(l_Siegel_Siegel__certificate___closed__5);
l_Siegel_Siegel__certificate___closed__6 = _init_l_Siegel_Siegel__certificate___closed__6();
lean_mark_persistent(l_Siegel_Siegel__certificate___closed__6);
l_Siegel_Siegel__certificate___closed__7 = _init_l_Siegel_Siegel__certificate___closed__7();
lean_mark_persistent(l_Siegel_Siegel__certificate___closed__7);
l_Siegel_Siegel__certificate___closed__8 = _init_l_Siegel_Siegel__certificate___closed__8();
lean_mark_persistent(l_Siegel_Siegel__certificate___closed__8);
l_Siegel_Siegel__certificate___closed__9 = _init_l_Siegel_Siegel__certificate___closed__9();
lean_mark_persistent(l_Siegel_Siegel__certificate___closed__9);
l_Siegel_Siegel__certificate___closed__10 = _init_l_Siegel_Siegel__certificate___closed__10();
lean_mark_persistent(l_Siegel_Siegel__certificate___closed__10);
l_Siegel_Siegel__certificate___closed__11 = _init_l_Siegel_Siegel__certificate___closed__11();
lean_mark_persistent(l_Siegel_Siegel__certificate___closed__11);
l_Siegel_Siegel__certificate = _init_l_Siegel_Siegel__certificate();
lean_mark_persistent(l_Siegel_Siegel__certificate);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
