

#ifndef _CPP_U8GLIB
#define _CPP_U8GLIB

#include <Print.h>
#include "clib/u8g.h"


class U8GLIB : public Print
{
  private:
    u8g_t u8g;
    u8g_uint_t tx, ty;          // current position for the Print base class procedures
    uint8_t is_begin;

    void prepare(void) { tx = 0; ty = 0; is_begin = 0; }
    void cbegin(void) { if ( is_begin == 0 ) { is_begin = 1; u8g_Begin(&u8g); } }
   
	
    uint8_t initI2C(u8g_dev_t *dev, uint8_t options){
		prepare();
		return u8g_InitI2C(&u8g, dev, options);
	}
	
  
  public:
  
    /* constructor */
    U8GLIB(u8g_dev_t *dev, uint8_t options) { 
	  initI2C(dev, options); 
	}

    uint8_t begin(void) { is_begin = 1; return u8g_Begin(&u8g); }
      
    void setPrintPos(u8g_uint_t x, u8g_uint_t y) { tx = x; ty = y; }
    u8g_t *getU8g(void) { return &u8g; }
    u8g_uint_t getPrintCol(void) { return tx; }	
    u8g_uint_t getPrintRow(void) { return ty; }    
    
    /* implementation of the write interface to the print class */
    size_t write(uint8_t c) { tx += u8g_DrawGlyph(&u8g, tx, ty, c); return 1;}
    
     /* screen rotation */
    void undoRotation(void) { u8g_UndoRotation(&u8g); }
    void setRot90(void) { u8g_SetRot90(&u8g); }
    void setRot180(void) { u8g_SetRot180(&u8g); }
    void setRot270(void) { u8g_SetRot270(&u8g); }

     /* screen scaling */
    void undoScale(void) { u8g_UndoScale(&u8g); }
    void setScale2x2(void) { u8g_SetScale2x2(&u8g); }
    
     /* picture loop */
    void firstPage(void) { cbegin(); u8g_FirstPage(&u8g); }
    uint8_t nextPage(void) { return u8g_NextPage(&u8g); }
    
    /* system commands */
    uint8_t setContrast(uint8_t contrast) { cbegin(); return u8g_SetContrast(&u8g, contrast); }
    void sleepOn(void) { u8g_SleepOn(&u8g); }
    void sleepOff(void) { u8g_SleepOff(&u8g); }
    
    /* graphic primitives */
    void setColorEntry(uint8_t color_index, uint8_t r, uint8_t g, uint8_t b) { u8g_SetColorEntry(&u8g, color_index, r, g, b); }
    void setHiColor(uint16_t  rgb) { u8g_SetHiColor(&u8g, rgb); }
    void setHiColorByRGB(uint8_t r, uint8_t g, uint8_t b) { u8g_SetHiColorByRGB(&u8g, r, g, b); }
    void setRGB(uint8_t r, uint8_t g, uint8_t b) { u8g_SetRGB(&u8g, r, g, b); }
    
    void setColorIndex(uint8_t color_index) { u8g_SetColorIndex(&u8g, color_index); }
    uint8_t getColorIndex(void) { return u8g_GetColorIndex(&u8g); }
    
    void setDefaultForegroundColor(void) { u8g_SetDefaultForegroundColor(&u8g);  }
    void setDefaultBackgroundColor(void) { u8g_SetDefaultBackgroundColor(&u8g);  }
    void setDefaultMidColor(void) { u8g_SetDefaultMidColor(&u8g);  }
    
    u8g_uint_t getWidth(void) { return u8g_GetWidth(&u8g); }
    u8g_uint_t getHeight(void) { return u8g_GetHeight(&u8g); }
    uint8_t getMode(void) { return u8g_GetMode(&u8g); }

    void drawPixel(u8g_uint_t x, u8g_uint_t y) { return u8g_DrawPixel(&u8g, x, y); }
    void drawHLine(u8g_uint_t x, u8g_uint_t y, u8g_uint_t w) { u8g_DrawHLine(&u8g, x, y, w); }  
    void drawVLine(u8g_uint_t x, u8g_uint_t y, u8g_uint_t h) { u8g_DrawVLine(&u8g, x, y, h); }
    void drawLine(u8g_uint_t x1, u8g_uint_t y1, u8g_uint_t x2, u8g_uint_t y2) { u8g_DrawLine(&u8g, x1, y1, x2, y2); }
    
    void drawFrame(u8g_uint_t x, u8g_uint_t y, u8g_uint_t w, u8g_uint_t h) { u8g_DrawFrame(&u8g, x, y, w, h); }
    void drawRFrame(u8g_uint_t x, u8g_uint_t y, u8g_uint_t w, u8g_uint_t h, u8g_uint_t r) { u8g_DrawRFrame(&u8g, x, y, w, h,r); }
    void drawBox(u8g_uint_t x, u8g_uint_t y, u8g_uint_t w, u8g_uint_t h) { u8g_DrawBox(&u8g, x, y, w, h); }
    void drawRBox(u8g_uint_t x, u8g_uint_t y, u8g_uint_t w, u8g_uint_t h, u8g_uint_t r) { u8g_DrawRBox(&u8g, x, y, w, h,r); }

    void drawCircle(u8g_uint_t x0, u8g_uint_t y0, u8g_uint_t rad, uint8_t opt = U8G_DRAW_ALL) { u8g_DrawCircle(&u8g, x0, y0, rad, opt); }
    void drawDisc(u8g_uint_t x0, u8g_uint_t y0, u8g_uint_t rad, uint8_t opt = U8G_DRAW_ALL) { u8g_DrawDisc(&u8g, x0, y0, rad, opt); }
     
    void drawEllipse(u8g_uint_t x0, u8g_uint_t y0, u8g_uint_t rx, u8g_uint_t ry, uint8_t opt = U8G_DRAW_ALL) { u8g_DrawEllipse(&u8g, x0, y0, rx, ry, opt); }
    void drawFilledEllipse(u8g_uint_t x0, u8g_uint_t y0, u8g_uint_t rx, u8g_uint_t ry, uint8_t opt = U8G_DRAW_ALL) { u8g_DrawFilledEllipse(&u8g, x0, y0, rx, ry, opt); }    

    void drawTriangle(uint16_t x0, uint16_t y0, uint16_t x1, uint16_t y1, uint16_t x2, uint16_t y2) 
      { u8g_DrawTriangle(&u8g, x0, y0, x1, y1, x2, y2); }
      

    
    /* bitmap handling */
    void drawBitmap(u8g_uint_t x, u8g_uint_t y, u8g_uint_t cnt, u8g_uint_t h, const uint8_t *bitmap) 
      { u8g_DrawBitmap(&u8g, x, y, cnt, h, bitmap); }
    void drawBitmapP(u8g_uint_t x, u8g_uint_t y, u8g_uint_t cnt, u8g_uint_t h, const u8g_pgm_uint8_t *bitmap)
      { u8g_DrawBitmapP(&u8g, x, y, cnt, h, bitmap); }

    void drawXBM(u8g_uint_t x, u8g_uint_t y, u8g_uint_t w, u8g_uint_t h, const uint8_t *bitmap)
      { u8g_DrawXBM(&u8g, x, y, w, h, bitmap); }
    void drawXBMP(u8g_uint_t x, u8g_uint_t y, u8g_uint_t w, u8g_uint_t h, const u8g_pgm_uint8_t *bitmap)
      { u8g_DrawXBMP(&u8g, x, y, w, h, bitmap); }
    
      
    /* font handling */
    void setFont(const u8g_fntpgm_uint8_t *font) {u8g_SetFont(&u8g, font); }
    int8_t getFontAscent(void) { return u8g_GetFontAscent(&u8g); }
    int8_t getFontDescent(void) { return u8g_GetFontDescent(&u8g); }
    int8_t getFontLineSpacing(void) { return u8g_GetFontLineSpacing(&u8g); }
    
    u8g_uint_t drawStr(u8g_uint_t x, u8g_uint_t y, const char *s) { return u8g_DrawStr(&u8g, x, y, s); }
    u8g_uint_t drawStr90(u8g_uint_t x, u8g_uint_t y, const char *s) { return u8g_DrawStr90(&u8g, x, y, s); }
    u8g_uint_t drawStr180(u8g_uint_t x, u8g_uint_t y, const char *s) { return u8g_DrawStr180(&u8g, x, y, s); }
    u8g_uint_t drawStr270(u8g_uint_t x, u8g_uint_t y, const char *s) { return u8g_DrawStr270(&u8g, x, y, s); }
    u8g_uint_t drawStrP(u8g_uint_t x, u8g_uint_t y, const u8g_pgm_uint8_t *s) { return u8g_DrawStrP(&u8g, x, y, s); }
    u8g_uint_t drawStr90P(u8g_uint_t x, u8g_uint_t y, const u8g_pgm_uint8_t *s) { return u8g_DrawStr90P(&u8g, x, y, s); }
    u8g_uint_t drawStr180P(u8g_uint_t x, u8g_uint_t y, const u8g_pgm_uint8_t *s) { return u8g_DrawStr180P(&u8g, x, y, s); }
    u8g_uint_t drawStr270P(u8g_uint_t x, u8g_uint_t y, const u8g_pgm_uint8_t *s) { return u8g_DrawStr270P(&u8g, x, y, s); }
    
    void setFontPosBaseline(void) { u8g_SetFontPosBaseline(&u8g); }
    void setFontPosBottom(void) { u8g_SetFontPosBottom(&u8g); }
    void setFontPosCenter(void) { u8g_SetFontPosCenter(&u8g); }
    void setFontPosTop(void) { u8g_SetFontPosTop(&u8g); }

    void setFontRefHeightText(void) { u8g_SetFontRefHeightText(&u8g); }
    void setFontRefHeightExtendedText(void) { u8g_SetFontRefHeightExtendedText(&u8g); }
    void setFontRefHeightAll(void) { u8g_SetFontRefHeightAll(&u8g); }  
    void setFontLineSpacingFactor(uint8_t factor) { u8g_SetFontLineSpacingFactor(&u8g, factor); }



};






class U8GLIB_SSD1306_128X64 : public U8GLIB 
{
  public:
    
    U8GLIB_SSD1306_128X64(uint8_t options = U8G_I2C_OPT_NONE) 
      : U8GLIB(&u8g_dev_ssd1306_128x64_i2c, options)
      { }
};



#endif /* _CPP_U8GLIB */
