#include <stdlib.h>
#include <unistd.h>

static int	*board;
static int	n;

static void	ft_putnbr(int nb)
{
	char	c;

	if (nb >= 10)
		ft_putnbr(nb / 10);
	c = '0' + nb % 10;
	write(1, &c, 1);
}

static void	print_solution(void)
{
	int	i;

	i = 0;
	while (i < n)
	{
		if (i > 0)
			write(1, " ", 1);
		ft_putnbr(board[i]);
		i++;
	}
	write(1, "\n", 1);
}

static int	is_safe(int col, int row)
{
	int	i;

	i = 0;
	while (i < col)
	{
		if (board[i] == row)
			return (0);
		if (board[i] - row == i - col || board[i] - row == col - i)
			return (0);
		i++;
	}
	return (1);
}

static void	solve(int col)
{
	int	row;

	if (col == n)
	{
		print_solution();
		return ;
	}
	row = 0;
	while (row < n)
	{
		if (is_safe(col, row))
		{
			board[col] = row;
			solve(col + 1);
		}
		row++;
	}
}

int	main(int argc, char **argv)
{
	if (argc != 2)
		return (1);
	n = atoi(argv[1]);
	if (n <= 0)
		return (0);
	board = calloc(n, sizeof(int));
	if (!board)
		return (1);
	solve(0);
	free(board);
	return (0);
}
