#ifndef RENDERHELPER_HPP
#define RENDERHELPER_HPP 

#include <string>
#include <iostream>
#include <SDL.h>
#include <SDL_image.h>
#include <SDL_ttf.h>
#include <SDL_pixels.h>

class RenderHelper{
    public:
        static void renderTexture(SDL_Texture *tex, SDL_Renderer *ren, int x, int y, int w, int h);
        static void renderTexture(SDL_Texture *tex, SDL_Renderer *ren, int x, int y);
        static void renderTexture(SDL_Texture *tex, SDL_Renderer *ren, int x, int y, double angle, SDL_RendererFlip flip);
        static SDL_Texture* renderText(const std::string &message, TTF_Font* font, SDL_Color color, SDL_Renderer *renderer);
};

#endif

