#include <stdio.h>
#include <stdbool.h>

#include <SDL.h>
#include <SDL_ttf.h>

// Define MAX and MIN macros
#define MAX(X, Y) (((X) > (Y)) ? (X) : (Y))
#define MIN(X, Y) (((X) < (Y)) ? (X) : (Y))

// Define screen dimensions
#define SCREEN_WIDTH    480
#define SCREEN_HEIGHT   272

#define FONT_PATH   "./Pacifico.ttf"

int main(int argc, char* argv[])
{
    // use dummy video driver
    SDL_setenv("SDL_VIDEODRIVER","rtt",1);

    // Initialize SDL2
    if(SDL_Init(SDL_INIT_VIDEO) < 0)
    {
        printf("SDL2 could not be initialized!\n"
               "SDL2 Error: %s\n", SDL_GetError());
        return 0;
    }

    // Initialize SDL2_ttf
    TTF_Init();

    // Create window
    SDL_Window *window = SDL_CreateWindow("SDL2_ttf sample",
                                          SDL_WINDOWPOS_UNDEFINED,
                                          SDL_WINDOWPOS_UNDEFINED,
                                          SCREEN_WIDTH, SCREEN_HEIGHT,
                                          SDL_WINDOW_SHOWN);
    if(!window)
    {
        printf("Window could not be created!\n"
               "SDL_Error: %s\n", SDL_GetError());
    }
    else
    {
        // Create renderer
        SDL_Renderer *renderer = SDL_CreateRenderer(window, -1, 0);
        if(!renderer)
        {
            printf("Renderer could not be created!\n"
                   "SDL_Error: %s\n", SDL_GetError());
        }
        else
        {
            // Declare rect of square
            SDL_Rect squareRect;

            // Square dimensions: Half of the min(SCREEN_WIDTH, SCREEN_HEIGHT)
            squareRect.w = MIN(SCREEN_WIDTH, SCREEN_HEIGHT) / 2;
            squareRect.h = MIN(SCREEN_WIDTH, SCREEN_HEIGHT) / 2;

            // Square position: In the middle of the screen
            squareRect.x = SCREEN_WIDTH / 2 - squareRect.w / 2;
            squareRect.y = SCREEN_HEIGHT / 2 - squareRect.h / 2;

            TTF_Font *font = TTF_OpenFont(FONT_PATH, 40);
            if(!font) {
                printf("Unable to load font: '%s'!\n"
                       "SDL2_ttf Error: %s\n", FONT_PATH, TTF_GetError());
                return 0;
            }

            SDL_Color textColor           = { 0x00, 0x00, 0x00, 0xFF };
            SDL_Color textBackgroundColor = { 0xFF, 0xFF, 0xFF, 0xFF };
            SDL_Texture *text = NULL;
            SDL_Rect textRect;

            SDL_Surface *textSurface = TTF_RenderText_Shaded(font, "Red square", textColor, textBackgroundColor);
            if(!textSurface) {
                printf("Unable to render text surface!\n"
                       "SDL2_ttf Error: %s\n", TTF_GetError());
            } else {
                // Create texture from surface pixels
                text = SDL_CreateTextureFromSurface(renderer, textSurface);
                if(!text) {
                    printf("Unable to create texture from rendered text!\n"
                           "SDL2 Error: %s\n", SDL_GetError());
                    return 0;
                }

                // Get text dimensions
                textRect.w = textSurface->w;
                textRect.h = textSurface->h;

                SDL_FreeSurface(textSurface);
            }

            textRect.x = (SCREEN_WIDTH - textRect.w) / 2;
            textRect.y = squareRect.y - textRect.h - 10;


            // Event loop exit flag
            bool quit = false;

            // Event loop
            while(!quit)
            {
                SDL_Event e;

                // Wait indefinitely for the next available event
                SDL_WaitEvent(&e);

                // User requests quit
                if(e.type == SDL_QUIT)
                {
                    quit = true;
                }

                // Initialize renderer color white for the background
                SDL_SetRenderDrawColor(renderer, 0xFF, 0xFF, 0xFF, 0xFF);

                // Clear screen
                SDL_RenderClear(renderer);

                // Set renderer color red to draw the square
                SDL_SetRenderDrawColor(renderer, 0xFF, 0x00, 0x00, 0xFF);

                // Draw filled square
                SDL_RenderFillRect(renderer, &squareRect);

                // Draw text
                SDL_RenderCopy(renderer, text, NULL, &textRect);

                // Update screen
                SDL_RenderPresent(renderer);
            }

            // Destroy renderer
            SDL_DestroyRenderer(renderer);
        }

        // Destroy window
        SDL_DestroyWindow(window);
    }

    // Quit SDL2_ttf
    TTF_Quit();

    // Quit SDL
    SDL_Quit();

    return 0;
}
