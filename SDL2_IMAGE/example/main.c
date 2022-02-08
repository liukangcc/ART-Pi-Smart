

#include <SDL.h>
#include <SDL_image.h>
#include <stdio.h>

extern Uint32 rtt_screen_width;
extern Uint32 rtt_screen_heigth;

void usage(char * proc_name)
{
	printf("\nUsage: %s option\n", proc_name);
	printf(	"\toption:\n"
		"\t-p	draw a png picture with texture\n"
		"\t-g	draw a gif picture with texture\n");
}

int main (int argc, char *argv[]) 
{
    char *path = NULL;
    SDL_Surface* optimizedImg = NULL;
    SDL_Window *win = NULL;
    SDL_Surface *screenSurface = NULL;

    if(( argc != 3 ))
    {
        printf("error input arguments!\n");
        return(1);
    }
    path = argv[2];

    // use dummy video driver
    SDL_setenv("SDL_VIDEODRIVER","rtt", 1);

    if (SDL_Init(SDL_INIT_VIDEO) < 0) 
    {
        printf("could not initialize sdl2: %s\n", SDL_GetError());
        return -1;
    }

    win = SDL_CreateWindow("sdl2_image",
                            SDL_WINDOWPOS_UNDEFINED, 
                            SDL_WINDOWPOS_UNDEFINED,
                            rtt_screen_width, 
                            rtt_screen_heigth,
                            SDL_WINDOW_SHOWN);
    if (win == NULL)
    {
        printf("could not create window: %s\n", SDL_GetError());
        return -1;
    }

    if (0 == strcmp("-p",argv[1]))
    {
        if (!(IMG_Init(IMG_INIT_PNG) & IMG_INIT_PNG)) 
        {
            printf("could not initialize sdl2_image: %s\n", IMG_GetError());
            return -1;
        }

        screenSurface = SDL_GetWindowSurface(win);
        if (screenSurface == NULL) 
        {
            printf("could not get window: %s\n", SDL_GetError());
            goto _exit;
        }

        optimizedImg = SDL_ConvertSurface(IMG_Load(path), screenSurface->format, 0);
        if (optimizedImg == NULL) 
        {
            printf("could not optimize image: %s\n", SDL_GetError());
            goto _exit;
        }

        SDL_BlitSurface(optimizedImg, NULL, screenSurface, NULL);
        SDL_UpdateWindowSurface(win);
        SDL_Delay(2000);
    }
_exit:
    if (screenSurface)
    {
        SDL_FreeSurface(screenSurface);
    }

    if (optimizedImg)
    {
        SDL_FreeSurface(optimizedImg);
    }

    if (win)
    {
        SDL_DestroyWindow(win);
    }

    SDL_Quit();

    return 0;
}
