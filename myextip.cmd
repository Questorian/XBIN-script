@perl -MHTTP::Tiny -E "print HTTP::Tiny->new->get(shift)->{content}" http://www.whatismyip.org/