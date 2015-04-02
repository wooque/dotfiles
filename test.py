def fac(n):
    if n == 1 or n == 0:
        return 1
    return n * fac(n-1)

__name__ == "__main__":
    print fac(10)
