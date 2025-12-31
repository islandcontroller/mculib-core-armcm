.syntax unified
.cpu cortex-m0
.fpu softvfp
.thumb

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

/* Initialise memory sections                                                 */
__crt0_clear_bss:
  ldr   r0,   =_sbss                  /* Start of .bss section                */
  ldr   r1,   =_ebss                  /* End of .bss section                  */
  movs  r4,   #0                      /* Fill value                           */
__crt0_clear_bss_loop:
  cmp   r0,   r1
  bge   __crt0_copy_data              /* Done or skip if no .bss present      */
  str   r4,   [r0]
  adds  r0,   r0,   #4                /* Word-wise increment of write addr    */
  b     __crt0_clear_bss_loop

__crt0_copy_data:
  ldr   r0,   =_sidata                /* Start LMA of .data section ("src")   */
  ldr   r1,   =_sdata                 /* Start VMA of .data section ("dest")  */
  ldr   r2,   =_edata                 /* End VMA of .data section             */
__crt0_copy_data_loop:
  cmp   r1,   r2
  bge   _app_start                    /* Done or skip if no .data present     */
  ldr   r4,   [r0]                    /* Load word from LMA                   */
  str   r4,   [r1]                    /* Store word to VMA                    */
  adds  r0,   r0,   #4                /* Word-wise pointer increment          */
  adds  r1,   r1,   #4
  b     __crt0_copy_data_loop

/* Jump to main() function                                                    */
_app_start:
  bl    SystemInit                    /* Core system init                     */
__app_main_enter:
  movs  r0,   #0                      /* argc = 0                             */
  movs  r1,   #0                      /* argv = NULL                          */
  bl    main                          /* Call main() with return address      */
__app_main_exit:
  b     __app_main_exit               /* Endless loop                         */
