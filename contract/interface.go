package contract

type StateContext interface {
	PutState(key []byte, value []byte) error

	GetState(key []byte) ([]byte, error)

	GetSender() []byte
}

type SmartContract interface {
	GetName() []byte

	SetContext(ctx StateContext)
}
