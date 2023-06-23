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

/*
  replace("/etc", "etc");
*/
  replace("/etc/%s/%s", "etc/%s/%s");

  write_file(path);
}

int main()
{
  process("lib/firefox/libxul.so.124.0");

  return 0;
}

