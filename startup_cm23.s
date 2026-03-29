.syntax unified
.cpu cortex-m23
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
  mov   r0,   #0
  mov   r1,   #0
  mov   r2,   #0
  mov   r3,   #0
  mov   r4,   #0
  mov   r5,   #0
  mov   r6,   #0
  mov   r7,   #0
  mov   r8,   #0
  mov   r9,   #0
  mov   r10,  #0
  mov   r11,  #0
  mov   r12,  #0
  /* skip sp, lr, pc */

/* Initialise memory sections                                                 */
__crt0_clear_bss:
  ldr   r0,   =_sbss                  /* Start of .bss section                */
  ldr   r1,   =_ebss                  /* End of .bss section                  */
  mov   r4,   #0                      /* Fill value                           */
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
  mov   r0,   #0                      /* argc = 0                             */
  mov   r1,   #0                      /* argv = NULL                          */
  bl    main                          /* Call main() with return address      */
__app_main_exit:
  b     __app_main_exit               /* Endless loop                         */
