class_name UUID


static func v7():
	var bytes = PackedByteArray()
	bytes.resize(16)

	var unix_time_ms = int(Time.get_unix_time_from_system() * 1000)
	var rands = [randi(), randi(), randi()]

	bytes[0] = (unix_time_ms >> 40) & 0xff
	bytes[1] = (unix_time_ms >> 32) & 0xff
	bytes[2] = (unix_time_ms >> 24) & 0xff
	bytes[3] = (unix_time_ms >> 16) & 0xff

	bytes[4] = (unix_time_ms >> 8) & 0xff
	bytes[5] = unix_time_ms & 0xff
	bytes[6] = 0x70 | ((rands[0] >> 24) & 0x0f)
	bytes[7] = (rands[0] >> 16) & 0xff

	bytes[8] = 0x80 | (rands[0] >> 8) & 0x3f
	bytes[9] = rands[0] & 0xff
	bytes[10] = (rands[1] >> 24) & 0xff
	bytes[11] = (rands[1] >> 16) & 0xff

	bytes[12] = (rands[1] >> 8) & 0xff
	bytes[13] = rands[1] & 0xff
	bytes[14] = (rands[2] >> 24) & 0xff
	bytes[15] = (rands[2] >> 16) & 0xff

	return "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x" % Array(bytes)
