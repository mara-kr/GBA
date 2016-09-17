#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "rmapats.h"

scalar dummyScalar;
scalar fScalarIsForced=0;
scalar fScalarIsReleased=0;
scalar fScalarHasChanged=0;
scalar fForceFromNonRoot=0;
scalar fNettypeIsForced=0;
scalar fNettypeIsReleased=0;
void  hsG_0 (struct dummyq_struct * I1008, EBLK  * I1009, U  I714);
void  hsG_0 (struct dummyq_struct * I1008, EBLK  * I1009, U  I714)
{
    U  I1238;
    U  I1239;
    U  I1240;
    struct futq * I1241;
    I1238 = ((U )vcs_clocks) + I714;
    I1240 = I1238 & 0xfff;
    I1009->I647 = (EBLK  *)(-1);
    I1009->I651 = I1238;
    if (I1238 < (U )vcs_clocks) {
        I1239 = ((U  *)&vcs_clocks)[1];
        sched_millenium(I1008, I1009, I1239 + 1, I1238);
    }
    else if ((peblkFutQ1Head != ((void *)0)) && (I714 == 1)) {
        I1009->I652 = (struct eblk *)peblkFutQ1Tail;
        peblkFutQ1Tail->I647 = I1009;
        peblkFutQ1Tail = I1009;
    }
    else if ((I1241 = I1008->I974[I1240].I664)) {
        I1009->I652 = (struct eblk *)I1241->I663;
        I1241->I663->I647 = (RP )I1009;
        I1241->I663 = (RmaEblk  *)I1009;
    }
    else {
        sched_hsopt(I1008, I1009, I1238);
    }
}
#ifdef __cplusplus
extern "C" {
#endif
void SinitHsimPats(void);
#ifdef __cplusplus
}
#endif
