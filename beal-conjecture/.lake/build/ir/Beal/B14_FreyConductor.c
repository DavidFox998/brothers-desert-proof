// Lean compiler output
// Module: Beal.B14_FreyConductor
// Imports: Init Beal.B14_FreyConductor_Core Beal.B13_RibetRealDefs Beal.B01_Def Beal.B10_RibetReal_Core Mathlib.Data.Nat.Factorization.Basic Mathlib.Tactic
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
static lean_object* l_BealFreyConductor_Rad___closed__1;
LEAN_EXPORT lean_object* l_BealFreyConductor_FreyConductorReal(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_BealFreyConductor_Rad___boxed(lean_object*);
LEAN_EXPORT lean_object* l_BealFreyConductor_Rad___lambda__1(lean_object*);
LEAN_EXPORT lean_object* l_BealFreyConductor_FreyConductorReal___boxed(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_BealFreyConductor_Rad___lambda__1___boxed(lean_object*);
lean_object* l_Finset_prod___at_Nat_factorizationEquiv___elambda__1___spec__2(lean_object*, lean_object*);
lean_object* lean_nat_mul(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_BealFreyConductor_Rad(lean_object*);
lean_object* l_Nat_primeFactors(lean_object*);
LEAN_EXPORT lean_object* l_BealFreyConductor_Rad___lambda__1(lean_object* x_1) {
_start:
{
lean_inc(x_1);
return x_1;
}
}
static lean_object* _init_l_BealFreyConductor_Rad___closed__1() {
_start:
{
lean_object* x_1; 
x_1 = lean_alloc_closure((void*)(l_BealFreyConductor_Rad___lambda__1___boxed), 1, 0);
return x_1;
}
}
LEAN_EXPORT lean_object* l_BealFreyConductor_Rad(lean_object* x_1) {
_start:
{
lean_object* x_2; lean_object* x_3; lean_object* x_4; 
x_2 = l_Nat_primeFactors(x_1);
x_3 = l_BealFreyConductor_Rad___closed__1;
x_4 = l_Finset_prod___at_Nat_factorizationEquiv___elambda__1___spec__2(x_2, x_3);
return x_4;
}
}
LEAN_EXPORT lean_object* l_BealFreyConductor_Rad___lambda__1___boxed(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = l_BealFreyConductor_Rad___lambda__1(x_1);
lean_dec(x_1);
return x_2;
}
}
LEAN_EXPORT lean_object* l_BealFreyConductor_Rad___boxed(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = l_BealFreyConductor_Rad(x_1);
lean_dec(x_1);
return x_2;
}
}
LEAN_EXPORT lean_object* l_BealFreyConductor_FreyConductorReal(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4, lean_object* x_5, lean_object* x_6) {
_start:
{
lean_object* x_7; lean_object* x_8; lean_object* x_9; lean_object* x_10; lean_object* x_11; 
x_7 = lean_nat_mul(x_1, x_2);
x_8 = lean_nat_mul(x_7, x_3);
lean_dec(x_7);
x_9 = l_BealFreyConductor_Rad(x_8);
lean_dec(x_8);
x_10 = lean_unsigned_to_nat(2u);
x_11 = lean_nat_mul(x_10, x_9);
lean_dec(x_9);
return x_11;
}
}
LEAN_EXPORT lean_object* l_BealFreyConductor_FreyConductorReal___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4, lean_object* x_5, lean_object* x_6) {
_start:
{
lean_object* x_7; 
x_7 = l_BealFreyConductor_FreyConductorReal(x_1, x_2, x_3, x_4, x_5, x_6);
lean_dec(x_6);
lean_dec(x_5);
lean_dec(x_4);
lean_dec(x_3);
lean_dec(x_2);
lean_dec(x_1);
return x_7;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_Beal_B14__FreyConductor__Core(uint8_t builtin, lean_object*);
lean_object* initialize_Beal_B13__RibetRealDefs(uint8_t builtin, lean_object*);
lean_object* initialize_Beal_B01__Def(uint8_t builtin, lean_object*);
lean_object* initialize_Beal_B10__RibetReal__Core(uint8_t builtin, lean_object*);
lean_object* initialize_Mathlib_Data_Nat_Factorization_Basic(uint8_t builtin, lean_object*);
lean_object* initialize_Mathlib_Tactic(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_Beal_B14__FreyConductor(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Beal_B14__FreyConductor__Core(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Beal_B13__RibetRealDefs(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Beal_B01__Def(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Beal_B10__RibetReal__Core(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Mathlib_Data_Nat_Factorization_Basic(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Mathlib_Tactic(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
l_BealFreyConductor_Rad___closed__1 = _init_l_BealFreyConductor_Rad___closed__1();
lean_mark_persistent(l_BealFreyConductor_Rad___closed__1);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
