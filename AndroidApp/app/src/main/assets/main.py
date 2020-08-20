def main():
    import os
    dir_path = os.path.dirname(os.path.realpath(__file__))
    out_file = '{}/HelloWorld.txt'.format(dir_path)
    with open(out_file, 'a') as the_file:
        the_file.write('It works!\nTest?\n')
        the_file.write('Pre socket import...\n')
        import socket
        the_file.write('Post socket import\n')


if __name__ == '__main__':
    main()


