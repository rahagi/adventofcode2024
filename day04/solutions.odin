package day04

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

import "core:log"
import "core:testing"

import "../utils"

@(private)
traverse :: proc(arr: ^[dynamic]string, start_x, start_y, inc_x, inc_y, n: int) -> string {
	current_x, current_y := start_x, start_y
	bytes := make([dynamic]byte)
	sb := strings.builder_make()
	for x := 0; x < n; x += 1 {
		if current_x < 0 || current_y < 0 || current_x >= len(arr[x]) || current_y >= len(arr) {
			break
		}
		strings.write_byte(&sb, arr[current_y][current_x])
		current_x += inc_x
		current_y += inc_y
	}

	return strings.to_string(sb)
}

a :: proc(input_path: string) -> int {
	data := utils.read_file(input_path)
	defer delete(data)
	it := string(data)

	word_search := make([dynamic]string)
	defer delete(word_search)
	for line in strings.split_lines_iterator(&it) {
		append(&word_search, line)
	}

	total := 0
	for i := 0; i < len(word_search); i += 1 {
		for letter, j in word_search[i] {
			if letter == 'X' {
				dir := [8]struct {
					x, y: int,
				}{{1, 0}, {-1, 0}, {-1, 1}, {1, 1}, {1, -1}, {-1, -1}, {0, -1}, {0, 1}}
				for d in dir {
					result := traverse(&word_search, j, i, d.x, d.y, 4)
					defer delete(result)
					if (result == "XMAS") {
						total += 1
					}
				}
			}
		}
	}

	return total
}

@(test)
a_example :: proc(t: ^testing.T) {
	result := a("./day04/example.txt")
	testing.expect_value(t, result, 18)
}

@(test)
a_real :: proc(t: ^testing.T) {
	result := a("./day04/input.txt")
	log.infof("a answer: %v", result)
}

b :: proc(input_path: string) -> int {
	data := utils.read_file(input_path)
	defer delete(data)
	it := string(data)

	word_search := make([dynamic]string)
	defer delete(word_search)
	for line in strings.split_lines_iterator(&it) {
		append(&word_search, line)
	}

	total := 0
	for i := 0; i < len(word_search); i += 1 {
		for letter, j in word_search[i] {
			if letter == 'M' {
				dir := [4]struct {
					x, y: int,
				}{{-1, 1}, {1, 1}, {1, -1}, {-1, -1}}
				mas_count := 0
				for d in dir {
					result := traverse(&word_search, j, i, d.x, d.y, 3)
					defer delete(result)
					if (result == "MAS") {
						next_mas_x := j + d.x + 1 * d.x
						next_mas := traverse(&word_search, next_mas_x, i, -d.x, d.y, 3)
						defer delete(next_mas)
						if (next_mas == "SAM" || next_mas == "MAS") {
							total += 1
						}
					}
				}
			}
		}
	}

	return total / 2 // too lazy to do memoization to check overlaps xd
}

@(test)
b_example :: proc(t: ^testing.T) {
	result := b("./day04/example.txt")
	testing.expect_value(t, result, 9)
}

@(test)
b_real :: proc(t: ^testing.T) {
	result := b("./day04/input.txt")
	log.infof("b answer: %v", result)
}
