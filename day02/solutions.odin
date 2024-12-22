package day02

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

import "core:log"
import "core:testing"

import "../utils"

@(private)
Direction :: enum {
	Inc,
	Dec,
	None,
}

@(private)
dir_from_diff :: proc(diff: int) -> Direction {
	return .Inc if diff > 0 else .Dec
}

a :: proc(input_path: string) -> int {
	data := utils.read_file(input_path)
	defer delete(data)
	it := string(data)

	safe_count := 0
	for report in strings.split_lines_iterator(&it) {
		levels := strings.split(report, " ")
		defer delete(levels)

		before := 0
		dir: Direction = .None
		for level, i in levels {
			l, _ := strconv.parse_int(level)
			defer before = l
			if (i == 0) {continue}

			diff := l - before
			curr_dir := dir_from_diff(diff)
			defer dir = curr_dir
			if abs(diff) < 1 || abs(diff) > 3 {
				break
			}

			if dir != .None && curr_dir != dir {
				break
			}

			if i == len(levels) - 1 {
				safe_count += 1
			}
		}
	}

	return safe_count
}

@(test)
a_example :: proc(t: ^testing.T) {
	result := a("./day02/example.txt")
	testing.expect_value(t, result, 2)
}

@(test)
a_real :: proc(t: ^testing.T) {
	result := a("./day02/input.txt")
	log.infof("a answer: %v", result)
}
