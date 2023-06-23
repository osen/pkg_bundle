#include <stdio.h>
#include <stdlib.h>
#include <string.h>

unsigned char *fdata;
size_t fsize;

void error(char *message)
{
  printf("Error: %s\n", message);

  exit(1);
}

void read_file(const char *path)
{
  FILE *f = fopen(path, "rb");

  if(!f)
  {
    error("Failed to open file for reading");
  }

  fseek(f, 0, SEEK_END);
  fsize = ftell(f);
  fseek(f, 0, SEEK_SET);
  fdata = malloc(fsize);
  fread(fdata, fsize, 1, f);
  fclose(f);
}

void replace(const char *from, const char *to)
{
  size_t from_len = strlen(from) + 1;
  size_t to_len = strlen(to) + 1;

  for(size_t ci = 0; ci < fsize - from_len; ++ci)
  {
    int found = 1;

    for(size_t fi = 0; fi < from_len; ++fi)
    {
      if(fdata[ci + fi] != from[fi])
      {
        found = 0;

        break;
      }
    }

    if(!found)
    {
      continue;
    }

    printf("[info] Patching (%s)\n", to);

    for(size_t ti = 0; ti < to_len; ++ti)
    {
      fdata[ci + ti] = to[ti];
    }
  }
}

void write_file(const char *path)
{
  FILE *f = fopen(path, "wb");

  if(!f)
  {
    error("Failed to open file for writing");
  }

  fwrite(fdata, 1, fsize, f);
  fclose(f);
  free(fdata);
}

void process(const char *path)
{
  printf("[info] Processing (%s)\n", path);

  read_file(path);

  replace("/usr/local/lib/libGLEW.so.9.0", "libGLEW.so.9.0");
  replace("/usr/local/lib/libzstd.so.6.2", "libzstd.so.6.2");
  replace("/usr/local/lib/libbz2.so.10.4", "libbz2.so.10.4");
  replace("/usr/local/lib/libswscale.so.7.0", "libswscale.so.7.0");
  replace("/usr/local/lib/libavformat.so.22.0", "libavformat.so.22.0");
  replace("/usr/local/lib/libavcodec.so.25.0", "libavcodec.so.25.0");
  replace("/usr/local/lib/libgif.so.9.0", "libgif.so.9.0");
  replace("/usr/local/lib/libavutil.so.15.0", "libavutil.so.15.0");
  replace("/usr/local/lib/liblz4.so.3.2", "liblz4.so.3.2");

  write_file(path);
}

int main()
{
  process("bin/blender-bin");
  process("lib/libOpenImageIO.so.11.1");
  process("lib/libblosc.so.1.0");

  return 0;
}

