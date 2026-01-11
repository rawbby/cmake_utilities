int
main(int argc, char** argv)
{
  return argc != 2 || argv[1][0] != '-' || argv[1][1] != 'e';
}
