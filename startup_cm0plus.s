.syntax unified
.cpu cortex-m0plus
.fpu softvfp
.thumb

/******************************************************************************
 * Macro definitions
 ******************************************************************************/
/* Clear SRAM section
 * start: section start marker
 * end: section end marker                                                    */
.macro  clr_sec start, end
  ldr   r0,   =\start                 /* Section start address and cursor     */
  ldr   r1,   =\end                   /* Section end address                  */
  movs  r3,   #0                      /* Fill pattern                         */
1:
  cmp   r0,   r1                      /* Loop until cursor reaches end marker */
  bge   2f                            /* Done                                 */
  str   r3,   [r0]                    /* Store fill pattern at cursor         */
  adds  r0,   r0,   #4                /* Increment cursor                     */
  b     1b                            /* Loop                                 */
2:
.endm

/* Load SRAM section from LMA
 * start: section start marker
 * end: section end marker
 * src: load address marker                                                   */
.macro  ld_sec  start, end, src
  ldr   r0,   =\start                 /* Sec. start address and write cursor  */
  ldr   r1,   =\end                   /* Section end address                  */
  ldr   r2,   =\src                   /* Load data address and read cursor    */
1:
  cmp   r0,   r1                      /* Loop until write cursor reaches end  */
  bge   2f                            /* Done                                 */
  ldr   r3,   [r2]                    /* Load word from read cursor           */
  str   r3,   [r0]                    /* Store word at write cursor           */
  adds  r0,   r0,   #4                /* Increment cursors                    */
  adds  r2,   r2,   #4                /* -"-                                  */
  b     1b                            /* Loop                                 */
2:
.endm

/******************************************************************************
 * _start
 * Reset handler
 ******************************************************************************/
.section  .text.startup
.balign 4
.globl  _start
.type   _start, %function
_start:
  /* Clear registers                                                          */
  movs  r0,   #0
  movs  r1,   #0
  movs  r2,   #0
  movs  r3,   #0
  movs  r4,   #0
  movs  r5,   #0
  movs  r6,   #0
  movs  r7,   #0
  mov   r8,   r0                      /* ARMv6-M do not support mov #imm into */
  mov   r9,   r0                      /* high registers                       */
  mov   r10,  r0                      /* -"- */
  mov   r11,  r0                      /* -"- */
  mov   r12,  r0                      /* -"- */
  /* skip sp, lr, pc */

  /* Initialise memory sections                                               */
  clr_sec _sbss,  _ebss               /* .bss                                 */
  ld_sec  _sdata, _edata, _sidata     /* .data                                */


  /* Start application code                                                   */
  bl    SystemInit                    /* Core system init                     */

  movs  r0,   #0                      /* argc = 0                             */
  movs  r1,   #0                      /* argv = NULL                          */
  bl    main                          /* Call main() with return address      */
1:
  b     1b                            /* Endless loop                         */
