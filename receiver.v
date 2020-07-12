module channels

import sync

// Receiver is the sum of BlockReceiver and SelectReceiver
// 	created to get around lack of generic interfaces
struct Receiver {
	do fn(GenericValue)
    mut:
        v GenericValue
        m &sync.Mutex
		sel Select
}

fn (mut s Receiver) receive(value GenericValue) {
	if m != 0 {
    	defer {
        	s.m.unlock() 
        }
    	s.v = value
	} else {
		s.finished = true
		s.sel.m_unlock()
		if s.sel.b != none { s.sel.b.m_unlock() }
		s.do(value)
	}
}

fn (s Receiver) claim() bool {
	if s.m != 0 {
    	return true
	}
	return s.sel.claim()
}

fn (s Receiver) cancel() {
	if s.m == 0 {
		s.sel.cancel()
	}
}
