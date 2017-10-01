

void DrawVgaCircle(uint16_t x, uint16_t y, uint16_t w, uint16_t h)
{
	uint16_t radius 	= 5;
	uint16_t t_width	= 20;
	uint16_t t_height 	= 20;
	uint16_t c_x 		= t_width / 2;
	uint16_t c_y 		= t_height / 2;

	for (int x = 0; x < t_width; ++x)
	{
		for (int y = 0; y < t_height; ++y)
		{
			d = (x ^ 2 + y ^ 2)
			if (d > (radius - 2) || d < (radius + 2))
				//do something

		}
	}
}

