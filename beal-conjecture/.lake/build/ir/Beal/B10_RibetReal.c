// Lean compiler output
// Module: Beal.B10_RibetReal
// Imports: Init Beal.B10_RibetReal_Core Beal.B08_LevelLowering Beal.B09_FinalContradiction
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
LEAN_EXPORT lean_object* l_BealRibet_LevelAfterLowering;
static lean_object* _init_l_BealRibet_LevelAfterLowering() {
_start:
{
lean_object* x_1; 
x_1 = lean_unsigned_to_nat(2u);
return x_1;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_Beal_B10__RibetReal__Core(uint8_t builtin, lean_object*);
lean_object* initialize_Beal_B08__LevelLowering(uint8_t builtin, lean_object*);
lean_object* initialize_Beal_B09__FinalContradiction(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_Beal_B10__RibetReal(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Beal_B10__RibetReal__Core(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Beal_B08__LevelLowering(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Beal_B09__FinalContradiction(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
l_BealRibet_LevelAfterLowering = _init_l_BealRibet_LevelAfterLowering();
lean_mark_persistent(l_BealRibet_LevelAfterLowering);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
