; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-vectorize -mtriple=x86_64-unknown-linux-gnu -S < %s | FileCheck %s

; The test checks that there is no assert caused by issue described in PR35432

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@a = common local_unnamed_addr global [192 x [192 x i32]] zeroinitializer, align 16

; Function Attrs: nounwind uwtable
define i32 @main() local_unnamed_addr #0 {
; CHECK-LABEL: @main(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[I:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[S:%.*]] = alloca i16, align 2
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[I]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull [[TMP0]])
; CHECK-NEXT:    store i32 0, i32* [[I]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i16* [[S]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 2, i8* nonnull [[TMP1]])
; CHECK-NEXT:    [[CALL:%.*]] = call i32 (i32*, ...) bitcast (i32 (...)* @goo to i32 (i32*, ...)*)(i32* nonnull [[I]])
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[I]], align 4
; CHECK-NEXT:    [[STOREMERGE6:%.*]] = trunc i32 [[TMP2]] to i16
; CHECK-NEXT:    store i16 [[STOREMERGE6]], i16* [[S]], align 2
; CHECK-NEXT:    [[CONV17:%.*]] = and i32 [[TMP2]], 65472
; CHECK-NEXT:    [[CMP8:%.*]] = icmp eq i32 [[CONV17]], 0
; CHECK-NEXT:    br i1 [[CMP8]], label [[FOR_BODY_LR_PH:%.*]], label [[FOR_END12:%.*]]
; CHECK:       for.body.lr.ph:
; CHECK-NEXT:    [[TMP3:%.*]] = sub i32 -1, [[TMP2]]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[STOREMERGE_IN9:%.*]] = phi i32 [ [[TMP2]], [[FOR_BODY_LR_PH]] ], [ [[ADD:%.*]], [[FOR_INC9:%.*]] ]
; CHECK-NEXT:    [[CONV52:%.*]] = and i32 [[STOREMERGE_IN9]], 255
; CHECK-NEXT:    [[CMP63:%.*]] = icmp ult i32 [[TMP2]], [[CONV52]]
; CHECK-NEXT:    br i1 [[CMP63]], label [[FOR_BODY8_LR_PH:%.*]], label [[FOR_INC9]]
; CHECK:       for.body8.lr.ph:
; CHECK-NEXT:    [[CONV3:%.*]] = trunc i32 [[STOREMERGE_IN9]] to i8
; CHECK-NEXT:    [[DOTPROMOTED:%.*]] = load i32, i32* getelementptr inbounds ([192 x [192 x i32]], [192 x [192 x i32]]* @a, i64 0, i64 0, i64 0), align 16
; CHECK-NEXT:    [[TMP4:%.*]] = add i8 [[CONV3]], -1
; CHECK-NEXT:    [[TMP5:%.*]] = zext i8 [[TMP4]] to i32
; CHECK-NEXT:    [[TMP6:%.*]] = sub i32 -1, [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = icmp ugt i32 [[TMP3]], [[TMP6]]
; CHECK-NEXT:    [[UMAX:%.*]] = select i1 [[TMP7]], i32 [[TMP3]], i32 [[TMP6]]
; CHECK-NEXT:    [[TMP8:%.*]] = add i32 [[UMAX]], 2
; CHECK-NEXT:    [[TMP9:%.*]] = add i32 [[TMP8]], [[TMP5]]
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i32 [[TMP9]], 8
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_SCEVCHECK:%.*]]
; CHECK:       vector.scevcheck:
; CHECK-NEXT:    [[TMP10:%.*]] = add i8 [[CONV3]], -1
; CHECK-NEXT:    [[TMP11:%.*]] = zext i8 [[TMP10]] to i32
; CHECK-NEXT:    [[TMP12:%.*]] = sub i32 -1, [[TMP11]]
; CHECK-NEXT:    [[TMP13:%.*]] = icmp ugt i32 [[TMP3]], [[TMP12]]
; CHECK-NEXT:    [[UMAX1:%.*]] = select i1 [[TMP13]], i32 [[TMP3]], i32 [[TMP12]]
; CHECK-NEXT:    [[TMP14:%.*]] = add i32 [[UMAX1]], 1
; CHECK-NEXT:    [[TMP15:%.*]] = add i32 [[TMP14]], [[TMP11]]
; CHECK-NEXT:    [[TMP16:%.*]] = trunc i32 [[TMP15]] to i8
; CHECK-NEXT:    [[MUL:%.*]] = call { i8, i1 } @llvm.umul.with.overflow.i8(i8 1, i8 [[TMP16]])
; CHECK-NEXT:    [[MUL_RESULT:%.*]] = extractvalue { i8, i1 } [[MUL]], 0
; CHECK-NEXT:    [[MUL_OVERFLOW:%.*]] = extractvalue { i8, i1 } [[MUL]], 1
; CHECK-NEXT:    [[TMP17:%.*]] = add i8 [[TMP10]], [[MUL_RESULT]]
; CHECK-NEXT:    [[TMP18:%.*]] = sub i8 [[TMP10]], [[MUL_RESULT]]
; CHECK-NEXT:    [[TMP19:%.*]] = icmp ugt i8 [[TMP18]], [[TMP10]]
; CHECK-NEXT:    [[TMP20:%.*]] = icmp ult i8 [[TMP17]], [[TMP10]]
; CHECK-NEXT:    [[TMP21:%.*]] = select i1 true, i1 [[TMP19]], i1 [[TMP20]]
; CHECK-NEXT:    [[TMP22:%.*]] = icmp ugt i32 [[TMP15]], 255
; CHECK-NEXT:    [[TMP23:%.*]] = or i1 [[TMP21]], [[TMP22]]
; CHECK-NEXT:    [[TMP24:%.*]] = or i1 [[TMP23]], [[MUL_OVERFLOW]]
; CHECK-NEXT:    [[TMP25:%.*]] = or i1 false, [[TMP24]]
; CHECK-NEXT:    br i1 [[TMP25]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[TMP9]], 8
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[TMP9]], [[N_MOD_VF]]
; CHECK-NEXT:    [[CAST_CRD:%.*]] = trunc i32 [[N_VEC]] to i8
; CHECK-NEXT:    [[IND_END:%.*]] = sub i8 [[CONV3]], [[CAST_CRD]]
; CHECK-NEXT:    [[TMP26:%.*]] = insertelement <4 x i32> zeroinitializer, i32 [[DOTPROMOTED]], i32 0
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <4 x i32> [ [[TMP26]], [[VECTOR_PH]] ], [ [[TMP30:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI2:%.*]] = phi <4 x i32> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP31:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP27:%.*]] = trunc i32 [[INDEX]] to i8
; CHECK-NEXT:    [[OFFSET_IDX:%.*]] = sub i8 [[CONV3]], [[TMP27]]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i8> undef, i8 [[OFFSET_IDX]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i8> [[BROADCAST_SPLATINSERT]], <4 x i8> undef, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[INDUCTION:%.*]] = add <4 x i8> [[BROADCAST_SPLAT]], <i8 0, i8 -1, i8 -2, i8 -3>
; CHECK-NEXT:    [[INDUCTION3:%.*]] = add <4 x i8> [[BROADCAST_SPLAT]], <i8 -4, i8 -5, i8 -6, i8 -7>
; CHECK-NEXT:    [[TMP28:%.*]] = add i8 [[OFFSET_IDX]], 0
; CHECK-NEXT:    [[TMP29:%.*]] = add i8 [[OFFSET_IDX]], -4
; CHECK-NEXT:    [[TMP30]] = add <4 x i32> [[VEC_PHI]], <i32 1, i32 1, i32 1, i32 1>
; CHECK-NEXT:    [[TMP31]] = add <4 x i32> [[VEC_PHI2]], <i32 1, i32 1, i32 1, i32 1>
; CHECK-NEXT:    [[TMP32:%.*]] = add i8 [[TMP28]], -1
; CHECK-NEXT:    [[TMP33:%.*]] = add i8 [[TMP29]], -1
; CHECK-NEXT:    [[TMP34:%.*]] = zext i8 [[TMP32]] to i32
; CHECK-NEXT:    [[TMP35:%.*]] = zext i8 [[TMP33]] to i32
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 8
; CHECK-NEXT:    [[TMP36:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP36]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop !0
; CHECK:       middle.block:
; CHECK-NEXT:    [[BIN_RDX:%.*]] = add <4 x i32> [[TMP31]], [[TMP30]]
; CHECK-NEXT:    [[RDX_SHUF:%.*]] = shufflevector <4 x i32> [[BIN_RDX]], <4 x i32> undef, <4 x i32> <i32 2, i32 3, i32 undef, i32 undef>
; CHECK-NEXT:    [[BIN_RDX4:%.*]] = add <4 x i32> [[BIN_RDX]], [[RDX_SHUF]]
; CHECK-NEXT:    [[RDX_SHUF5:%.*]] = shufflevector <4 x i32> [[BIN_RDX4]], <4 x i32> undef, <4 x i32> <i32 1, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[BIN_RDX6:%.*]] = add <4 x i32> [[BIN_RDX4]], [[RDX_SHUF5]]
; CHECK-NEXT:    [[TMP37:%.*]] = extractelement <4 x i32> [[BIN_RDX6]], i32 0
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i32 [[TMP9]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_COND4_FOR_INC9_CRIT_EDGE:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i8 [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ [[CONV3]], [[FOR_BODY8_LR_PH]] ], [ [[CONV3]], [[VECTOR_SCEVCHECK]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ [[DOTPROMOTED]], [[FOR_BODY8_LR_PH]] ], [ [[DOTPROMOTED]], [[VECTOR_SCEVCHECK]] ], [ [[TMP37]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[FOR_BODY8:%.*]]
; CHECK:       for.body8:
; CHECK-NEXT:    [[INC5:%.*]] = phi i32 [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ], [ [[INC:%.*]], [[FOR_BODY8]] ]
; CHECK-NEXT:    [[C_04:%.*]] = phi i8 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[DEC:%.*]], [[FOR_BODY8]] ]
; CHECK-NEXT:    [[INC]] = add i32 [[INC5]], 1
; CHECK-NEXT:    [[DEC]] = add i8 [[C_04]], -1
; CHECK-NEXT:    [[CONV5:%.*]] = zext i8 [[DEC]] to i32
; CHECK-NEXT:    [[CMP6:%.*]] = icmp ult i32 [[TMP2]], [[CONV5]]
; CHECK-NEXT:    br i1 [[CMP6]], label [[FOR_BODY8]], label [[FOR_COND4_FOR_INC9_CRIT_EDGE]], !llvm.loop !2
; CHECK:       for.cond4.for.inc9_crit_edge:
; CHECK-NEXT:    [[INC_LCSSA:%.*]] = phi i32 [ [[INC]], [[FOR_BODY8]] ], [ [[TMP37]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    store i32 [[INC_LCSSA]], i32* getelementptr inbounds ([192 x [192 x i32]], [192 x [192 x i32]]* @a, i64 0, i64 0, i64 0), align 16
; CHECK-NEXT:    br label [[FOR_INC9]]
; CHECK:       for.inc9:
; CHECK-NEXT:    [[CONV10:%.*]] = and i32 [[STOREMERGE_IN9]], 65535
; CHECK-NEXT:    [[ADD]] = add nuw nsw i32 [[CONV10]], 1
; CHECK-NEXT:    [[CONV1:%.*]] = and i32 [[ADD]], 65472
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[CONV1]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_COND_FOR_END12_CRIT_EDGE:%.*]]
; CHECK:       for.cond.for.end12_crit_edge:
; CHECK-NEXT:    [[ADD_LCSSA:%.*]] = phi i32 [ [[ADD]], [[FOR_INC9]] ]
; CHECK-NEXT:    [[STOREMERGE:%.*]] = trunc i32 [[ADD_LCSSA]] to i16
; CHECK-NEXT:    store i16 [[STOREMERGE]], i16* [[S]], align 2
; CHECK-NEXT:    br label [[FOR_END12]]
; CHECK:       for.end12:
; CHECK-NEXT:    [[CALL13:%.*]] = call i32 (i16*, ...) bitcast (i32 (...)* @foo to i32 (i16*, ...)*)(i16* nonnull [[S]])
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 2, i8* nonnull [[TMP1]])
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull [[TMP0]])
; CHECK-NEXT:    ret i32 0
;
entry:
  %i = alloca i32, align 4
  %s = alloca i16, align 2
  %0 = bitcast i32* %i to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %0) #3
  store i32 0, i32* %i, align 4
  %1 = bitcast i16* %s to i8*
  call void @llvm.lifetime.start.p0i8(i64 2, i8* nonnull %1) #3
  %call = call i32 (i32*, ...) bitcast (i32 (...)* @goo to i32 (i32*, ...)*)(i32* nonnull %i) #3
  %2 = load i32, i32* %i, align 4
  %storemerge6 = trunc i32 %2 to i16
  store i16 %storemerge6, i16* %s, align 2
  %conv17 = and i32 %2, 65472
  %cmp8 = icmp eq i32 %conv17, 0
  br i1 %cmp8, label %for.body.lr.ph, label %for.end12

for.body.lr.ph:                                   ; preds = %entry
  br label %for.body

for.body:                                         ; preds = %for.body.lr.ph, %for.inc9
  %storemerge.in9 = phi i32 [ %2, %for.body.lr.ph ], [ %add, %for.inc9 ]
  %conv52 = and i32 %storemerge.in9, 255
  %cmp63 = icmp ult i32 %2, %conv52
  br i1 %cmp63, label %for.body8.lr.ph, label %for.inc9

for.body8.lr.ph:                                  ; preds = %for.body
  %conv3 = trunc i32 %storemerge.in9 to i8
  %.promoted = load i32, i32* getelementptr inbounds ([192 x [192 x i32]], [192 x [192 x i32]]* @a, i64 0, i64 0, i64 0), align 16
  br label %for.body8

for.body8:                                        ; preds = %for.body8.lr.ph, %for.body8
  %inc5 = phi i32 [ %.promoted, %for.body8.lr.ph ], [ %inc, %for.body8 ]
  %c.04 = phi i8 [ %conv3, %for.body8.lr.ph ], [ %dec, %for.body8 ]
  %inc = add i32 %inc5, 1
  %dec = add i8 %c.04, -1
  %conv5 = zext i8 %dec to i32
  %cmp6 = icmp ult i32 %2, %conv5
  br i1 %cmp6, label %for.body8, label %for.cond4.for.inc9_crit_edge

for.cond4.for.inc9_crit_edge:                     ; preds = %for.body8
  %inc.lcssa = phi i32 [ %inc, %for.body8 ]
  store i32 %inc.lcssa, i32* getelementptr inbounds ([192 x [192 x i32]], [192 x [192 x i32]]* @a, i64 0, i64 0, i64 0), align 16
  br label %for.inc9

for.inc9:                                         ; preds = %for.cond4.for.inc9_crit_edge, %for.body
  %conv10 = and i32 %storemerge.in9, 65535
  %add = add nuw nsw i32 %conv10, 1
  %conv1 = and i32 %add, 65472
  %cmp = icmp eq i32 %conv1, 0
  br i1 %cmp, label %for.body, label %for.cond.for.end12_crit_edge

for.cond.for.end12_crit_edge:                     ; preds = %for.inc9
  %add.lcssa = phi i32 [ %add, %for.inc9 ]
  %storemerge = trunc i32 %add.lcssa to i16
  store i16 %storemerge, i16* %s, align 2
  br label %for.end12

for.end12:                                        ; preds = %for.cond.for.end12_crit_edge, %entry
  %call13 = call i32 (i16*, ...) bitcast (i32 (...)* @foo to i32 (i16*, ...)*)(i16* nonnull %s) #3
  call void @llvm.lifetime.end.p0i8(i64 2, i8* nonnull %1) #3
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %0) #3
  ret i32 0
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

declare i32 @goo(...) local_unnamed_addr #2

declare i32 @foo(...) local_unnamed_addr #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1