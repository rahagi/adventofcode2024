package day03

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:text/regex"

import "core:log"
import "core:testing"

import "../utils"

a :: proc(input_path: string) -> int {
	data := utils.read_file(input_path)
	defer delete(data)
	input := string(data)
	r, err := regex.create("mul\\((\\d+),(\\d+)\\)", {.Global})
	if err != nil {
		log.error("regex didn't compile")
		os.exit(1)
	}
	defer regex.destroy(r)

	sum := 0
	pos := 0
	for match in regex.match_and_allocate_capture(r, input[pos:]) {
		defer regex.destroy(match)
		sum += strconv.atoi(match.groups[1]) * strconv.atoi(match.groups[2])
		pos += match.pos[0][1]
	}

	return sum
}

@(test)
a_example :: proc(t: ^testing.T) {
	result := a("./day03/example.txt")
	testing.expect_value(t, result, 161)
}

@(test)
a_real :: proc(t: ^testing.T) {
	result := a("./day03/input.txt")
	log.infof("a answer: %v", result)
}

b :: proc(input_path: string) -> int {
	data := utils.read_file(input_path)
	defer delete(data)
	input := string(data)
	r, err := regex.create("(don't|do)|(mul\\((\\d+),(\\d+)\\))", {.Global})
	if err != nil {
		log.error("regex didn't compile")
		os.exit(1)
	}
	defer regex.destroy(r)

	sum := 0
	pos := 0
	enabled := true
	for match in regex.match_and_allocate_capture(r, input[pos:]) {
		defer regex.destroy(match)
		instruction := match.groups[0]
		if instruction == "don't" {
			enabled = false
		} else if instruction == "do" {
			enabled = true
		} else {
			if enabled {
				sum += strconv.atoi(match.groups[2]) * strconv.atoi(match.groups[3])
			}
		}
		pos += match.pos[0][1]
	}

	return sum
}

@(test)
b_example :: proc(t: ^testing.T) {
	result := b("./day03/exampleb.txt")
	testing.expect_value(t, result, 48)
}

@(test)
b_real :: proc(t: ^testing.T) {
	result := b("./day03/input.txt")
	log.infof("a answer: %v", result)
}
