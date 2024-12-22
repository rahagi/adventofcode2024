package utils

import "core:os"

// caller must delete data
read_file :: proc(path: string) -> []byte {
	data, ok := os.read_entire_file(path)
	if !ok {
		return nil
	}

	return data
}

