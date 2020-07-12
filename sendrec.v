module channels

import sync

interface ClaimSender{
	claim() bool
	send(Receiver)
	cancel()
}

interface Sender{
	send(Receiver)
}

/*
interface ClaimReceiver {
	claim() bool
	receive(x GenericValue)
	cancel()
}

interface Receiver {
	receive(GenericValue)
}
*/

struct BlockingSender {
    value GenericValue
    mut:
        m &sync.Mutex 
}

fn (mut s BlockingSender) send(r Receiver) {
    defer { s.m.unlock() }
    return r.send(s.value)
}

fn (s BlockingSender) claim() bool {
    return true
}

fn (s BlockingSender) cancel() {}

// BlockingReceiver currently unused
struct BlockingReceiver {
    mut:
        v GenericValue
        m &sync.Mutex 
}

fn (mut s BlockingReceiver) receive(value GenericValue) {
    defer { s.m.unlock() }
    s.v = value
}

fn (s BlockingReceiver) claim() bool {
    return true
}

fn (s BlockingReceiver) cancel() {}
