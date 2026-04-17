package domain

// Generic
type Nullable[T any] struct {
	Value *T
	Set   bool
}
