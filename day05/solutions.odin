package day04

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

	input := string(data)
	manual := strings.split(input, "\n\n")
	defer delete(manual)

	assert(len(manual) == 2)
	rules, orders := manual[0], manual[1]

	rules_map := make(map[int]string)
	defer delete(rules_map)
	for line in strings.split_lines_iterator(&rules) {
		nums := strings.split(line, "|")
		defer delete(nums)
		assert(len(nums) == 2)
		l, r := strconv.atoi(nums[0]), nums[1]
		new_rule := [?]string{rules_map[l], " ", r}
		rules_map[l] = strings.concatenate(new_rule[:])
	}

	sum := 0
	for line in strings.split_lines_iterator(&orders) {
		is_valid := true
		middle_page := 0
		nums := strings.split(line, ",")
		defer delete(nums)
		for num, i in nums[:len(nums) - 1] {
			n := strconv.atoi(num)
			if (i == len(nums) / 2) {
				middle_page = n
			}
			next := nums[i + 1]
			if !strings.contains(rules_map[n], next) {
				is_valid = false
				break
			}
		}
		if is_valid {
			sum += middle_page
		}
	}

	return sum
}

@(test)
a_example :: proc(t: ^testing.T) {
	result := a("./day05/example.txt")
	testing.expect_value(t, result, 143)
}

@(test)
a_real :: proc(t: ^testing.T) {
	result := a("./day05/input.txt")
	log.infof("a answer: %v", result)
}
