#!/bin/sh

# Generate candidates for the longest pair of words in the Qwantzle.
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

# Letters used in the Qwantzle (case-sensitive)
# Note "I" is a special case and deliberately omitted
LETTER_POOL=ttttttttttttooooooooooeeeeeeeeaaaaaaallllll\
nnnnnnuuuuuuiiiiisssssdddddhhhhhyyyyyrrrfffbbwwkcmvg

if [ ! -x is_spellable ]; then
    echo "Error: Could not find ./is_spellable" >&2
    echo "Get the code from https://github.com/bmjcode/anagram" >&2
    exit 1
fi

if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/wordlist.txt" >&2
    exit 1
fi

TEMPFILE=$(mktemp)

# The longest word is 11 letters, and the next-longest is 8 letters
# They are side-by-side in the solution
LONGER_WORDS=$(grep -E '^[a-z]{11}$' $1)
SHORTER_WORDS=$(grep -E '^[a-z]{8}$' $1)
for LONGER in $LONGER_WORDS ; do
    for SHORTER in $SHORTER_WORDS ; do
        if ./is_spellable $LETTER_POOL $LONGER $SHORTER ; then
            # Either order is valid, and we have to consider each separately
            # to account for the distribution of "w"'s
            echo "$LONGER $SHORTER" >>$TEMPFILE
            echo "$SHORTER $LONGER" >>$TEMPFILE
        fi
    done
done

# There are two "w"'s in the solution, one of which is the last letter
# If there are two "w"'s in a pair, the second "w" must be the last letter
# and this pair must be the last phrase in the solution
grep -v -E '^.*w.*w[a-vx-z]+' $TEMPFILE | sort

rm -f $TEMPFILE
