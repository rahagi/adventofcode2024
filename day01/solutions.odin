package day01

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

import "core:log"
import "core:testing"

import "../utils"

a :: proc(input_path: string) -> int {
	data := utils.read_file(input_path)
	defer delete(data)
	it := string(data)

	arr_left := make([dynamic]int)
	arr_right := make([dynamic]int)
	defer delete(arr_left)
	defer delete(arr_right)

	for line in strings.split_lines_iterator(&it) {
		nums := strings.split(line, "   ")
		defer delete(nums)

		left, _ := strconv.parse_int(nums[0])
		right, _ := strconv.parse_int(nums[1])

		append(&arr_left, left)
		append(&arr_right, right)
	}

	slice.sort(arr_left[:])
	slice.sort(arr_right[:])

	assert(len(arr_left) == len(arr_right))

	sum := 0
	for i := 0; i < len(arr_left); i += 1 {
		sum += abs(arr_left[i] - arr_right[i])
	}

	return sum
}

@(test)
a_example :: proc(t: ^testing.T) {
	result := a("./day01/example.txt")
	testing.expect_value(t, result, 11)
}

@(test)
a_real :: proc(t: ^testing.T) {
	result := a("./day01/input.txt")
	log.infof("a answer: %v", result)
}

b :: proc(input_path: string) -> int {
	data := utils.read_file(input_path)
	defer delete(data)
	it := string(data)

	arr_left := make([dynamic]int)
	similarity_count := make(map[int]int)
	defer delete(arr_left)
	defer delete(similarity_count)
	for line in strings.split_lines_iterator(&it) {
		nums := strings.split(line, "   ")
		defer delete(nums)

		left, _ := strconv.parse_int(nums[0])
		right, _ := strconv.parse_int(nums[1])

		append(&arr_left, left)
		similarity_count[right] += 1
	}

	sum := 0
	for item in arr_left {
		sum += item * similarity_count[item]
	}

	return sum
}

@(test)
b_example :: proc(t: ^testing.T) {
	result := b("./day01/example.txt")
	testing.expect_value(t, result, 31)
}

@(test)
b_real :: proc(t: ^testing.T) {
	result := b("./day01/input.txt")
	log.infof("b answer: %v", result)
}
