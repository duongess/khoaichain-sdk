package contract

import (
	"fmt"

	"github.com/pelletier/go-toml/v2"
)

// BaseContract: parent struct for customer contracts to embed
type BaseContract struct {
	Name []byte
	Ctx  StateContext
}

// SetName sets the contract name
func (b *BaseContract) SetName(n []byte) {
	b.Name = n
}

func (b *BaseContract) SetContext(ctx StateContext) {
	b.Ctx = ctx
}

// GetName returns the contract name (default interface impl)
func (b *BaseContract) GetName() []byte {
	return b.Name
}

// Save persists any struct to the DB as TOML
func (b *BaseContract) Save(key []byte, data interface{}) error {
	if b.Ctx == nil {
		return fmt.Errorf("database context is not set (Ctx is nil)")
	}

	// Convert struct -> TOML bytes
	bytesData, err := toml.Marshal(data)
	if err != nil {
		return fmt.Errorf("failed to create TOML: %v", err)
	}

	// Compose scoped key: "contractname_key"
	// Example: "vericon_kho_hang_01"
	realKey := fmt.Sprintf("%s_%s", b.Name, key)

	// Write to DB
	return b.Ctx.PutState([]byte(realKey), bytesData)
}

// Get loads data from DB into the provided struct pointer
func (b *BaseContract) Get(key []byte, target interface{}) error {
	if b.Ctx == nil {
		return fmt.Errorf("database context is not set")
	}

	// Compose scoped key
	realKey := fmt.Sprintf("%s_%s", b.Name, key)

	// Fetch raw data from DB
	bytesData, err := b.Ctx.GetState([]byte(realKey))
	if err != nil {
		return err // not found or DB error
	}

	// Unmarshal TOML bytes into the struct
	err = toml.Unmarshal(bytesData, target)
	if err != nil {
		return fmt.Errorf("data in DB is not valid TOML: %v", err)
	}

	return nil
}

func (b *BaseContract) RequireCaller(allowed ...string) error {
	sender := b.Ctx.GetSender()
	for _, p := range allowed {
		if p == string(sender) {
			return nil
		}
	}
	return fmt.Errorf("access denied: sender '%s' is not authorized", sender)
}
