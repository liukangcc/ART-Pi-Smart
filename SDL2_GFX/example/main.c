#include <stdio.h>
#include <SDL2_gfxPrimitives.h>

#define WIDTH 480
#define HEIGHT 272

int main(int argc, char* argv[])
{

    // use dummy video driver
    SDL_setenv("SDL_VIDEODRIVER","rtt", 1);

   if (SDL_Init(SDL_INIT_VIDEO))
   {
      printf ("SDL_Init Error: %s", SDL_GetError());
      return 1;
   }

   SDL_Window *window = SDL_CreateWindow("SDL2_gfx test", SDL_WINDOWPOS_UNDEFINED, 
                            SDL_WINDOWPOS_UNDEFINED, WIDTH, HEIGHT, SDL_WINDOW_SHOWN);
   if (window == NULL)
   {
      printf ("SDL_CreateWindow Error: %s", SDL_GetError());
      SDL_Quit();
      return 2;
   }

   SDL_Renderer *renderer = SDL_CreateRenderer(window, -1, 0);
   if (renderer == NULL)
   {
      SDL_DestroyWindow(window);
      printf ("SDL_CreateRenderer Error: %s", SDL_GetError());
      SDL_Quit();
      return 3;
   }

   SDL_Event e;

   int quit = 0;
   while (!quit)
   {
      if (SDL_PollEvent(&e))
      {
         if (e.type == SDL_QUIT)
            quit = 1;
      }
      SDL_SetRenderDrawColor(renderer, 0, 0, 0xFF, 0xFF);
      SDL_RenderClear(renderer);
      thickLineColor(renderer, 0, 0, WIDTH, HEIGHT, 20, 0xFF00FFFF) ;
      thickLineColor(renderer, 0, HEIGHT, WIDTH, 0, 20, 0xFF00FFFF) ;
      SDL_RenderPresent(renderer);
      SDL_Delay(10);
   }

   SDL_DestroyRenderer(renderer);
   SDL_DestroyWindow(window);
   SDL_Quit();
   return 0;
}
