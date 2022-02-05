const std = @import("std");
const expect = std.testing.expect;

fn readFromFile(allocator: *std.mem.Allocator, filename: []const u8) ![]u8 {
    const buffer = try allocator.alloc(u8, 100000);
    var content = try std.fs.cwd().readFile(filename, buffer);
    return content;
}

fn readNumberList(allocator: *std.mem.Allocator, content: []u8) !*std.ArrayList(u32) {
    var numbers = std.ArrayList(u32).init(allocator);
    var builder: u32 = 0;
    for (content) |char| {
        if (char == '\n') {
            try numbers.append(builder);
            builder = 0;
        } else {
            builder = (builder << 1) | (char - 48);
        }
    }
    return &numbers;
}

fn countBinaryOccurence(numbers: []u32) [12]i16 {
    var counter_array = [_]i16{0} ** 12;
    for (numbers) |number| {
        var i: u5 = 0;
        //        var num: u32 = number;
        while (i < 12) : (i += 1) {
            var k: u32 = ((number & (@as(u32, 1) << i)) >> i);
            if (k == 1) {
                counter_array[11 - i] += 1;
            } else {
                counter_array[11 - i] -= 1;
            }
        }
    }
    return counter_array;
}

pub fn oxygenGeneratorRating(numbers: []u32, allocator: *std.mem.Allocator) !u32 {
    //    var counter_array = [_]i16{0} ** 12;
    var local_numbers: []u32 = numbers;

    var i: u5 = 11;
    //std.debug.print("{any} {any}\n", .{ local_numbers.ptr, local_numbers[0] });
    //        var num: u32 = number;
    while (i >= 0) : (i -= 1) {
        if (local_numbers.len == 1) break;

        var zero_numbers = std.ArrayList(u32).init(allocator);
        var one_numbers = std.ArrayList(u32).init(allocator);
        var common_counter: i16 = 0;
        for (local_numbers) |number| {
            var k: u32 = ((number & (@as(u32, 1) << i)) >> i);
            if (k == 1) {
                try one_numbers.append(number);
                common_counter += 1;
            } else {
                try zero_numbers.append(number);
                common_counter -= 1;
            }
        }
        if (common_counter >= 0) {
            local_numbers = one_numbers.items;
        } else {
            local_numbers = zero_numbers.items;
        }
    }
    return local_numbers[0];
}

pub fn co2ScrubberRating(numbers: []u32, allocator: *std.mem.Allocator) !u32 {
    //    var counter_array = [_]i16{0} ** 12;
    var local_numbers: []u32 = numbers;

    var i: u5 = 11;
    //std.debug.print("{any} {any}\n", .{ local_numbers.ptr, local_numbers[0] });
    //        var num: u32 = number;
    while (i >= 0) : (i -= 1) {
        if (local_numbers.len == 1) break;

        var zero_numbers = std.ArrayList(u32).init(allocator);
        var one_numbers = std.ArrayList(u32).init(allocator);
        var common_counter: i16 = 0;
        for (local_numbers) |number| {
            var k: u32 = ((number & (@as(u32, 1) << i)) >> i);
            if (k == 1) {
                try one_numbers.append(number);
                common_counter += 1;
            } else {
                try zero_numbers.append(number);
                common_counter -= 1;
            }
        }
        if (common_counter < 0) {
            local_numbers = one_numbers.items;
        } else {
            local_numbers = zero_numbers.items;
        }
    }
    return local_numbers[0];
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;
    const content = try readFromFile(allocator, "day3.in");
    var numbers = try readNumberList(allocator, content);
    var oxygenrating = try oxygenGeneratorRating(numbers.items[0..], allocator);
    var co2rating = try co2ScrubberRating(numbers.items[0..], allocator);
    std.debug.print("{b}\n", .{oxygenrating});
    std.debug.print("{b} \n", .{co2rating});
}
