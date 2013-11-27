/* 
 * to produce FLashBlink62.hex for downloading.
 * Use the FlashBurn application to download.
 */

ex1.out

-a

-map out2hex.map

-memwidth  8

-image

ROMS
{
  FLASH: org = 000h, len = 0x10000,romwidth = 8, files = {ex1.hex}
}
