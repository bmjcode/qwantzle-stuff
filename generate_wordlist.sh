#!/bin/sh

# Generate a list of valid words for the solution of the Qwantzle.
# Copyright (c) 2023 Benjamin Johnson <bmjcode@gmail.com>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

DICTIONARY=/usr/share/dict/words

# Letters used in the Qwantzle (case-sensitive)
LETTER_POOL=ttttttttttttooooooooooeeeeeeeeaaaaaaallllll\
nnnnnnuuuuuuiiiiisssssdddddhhhhhyyyyyIIIrrrfffbbwwkcmvg

if [ ! -r $DICTIONARY ]; then
    echo "Error: No dictionary found at $DICTIONARY" >&2
    exit 1
fi

if [ ! -x spellable ]; then
    echo "Error: Could not find ./spellable" >&2
    echo "Get the code from https://github.com/bmjcode/anagram" >&2
    exit 1
fi

if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/qwantzcorpus.txt" >&2
    exit 1
fi

# Keep it sorted by frequency count, but strip the number from the output.
# The longest word is 11 letters, and the second-longest is 8 letters.
# "I" and "a" (case-sensitive) are the only plausible one-letter words.
# The final letter is "w", and since there are only two "w"'s in the pool,
# we can omit words with two "w"'s where neither is the last letter
WORDS=$(grep -E '^[0-9]+ (a|[A-Za-z]{2,8}|[A-Za-z]{11})$' $1 \
	| grep -E -v '^[12] ' \
        | cut -d' ' -f2 \
        | tr '[:upper:]' '[:lower:]' \
        | grep -v -E '^[a-z]*w[a-z]*w[a-vx-z]+' \
	| ./spellable -l - $LETTER_POOL)

# The Qwantz Corpus is all lowercase. Fortunately, we only have one
# plausible uppercase word
echo I

# The words are all dictionary words
for WORD in $WORDS ; do
    # My copy of /usr/share/dict/words uses inconsistent capitalization
    grep -i -E "^$WORD$" $DICTIONARY | tr '[:upper:]' '[:lower:]'
done
