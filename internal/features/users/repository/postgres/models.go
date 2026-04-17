package users_postgres_repository

import "github.com/timotesttttt-netizen/golang-todoapp/internal/core/domain"

type UserModel struct {
	ID          int
	Version     int
	FullName    string
	PhoneNumber *string
}

func userDomainsFromModels(users []UserModel) []domain.User {
	userDomain := make([]domain.User, len(users))

	for i, user := range users {
		userDomain[i] = domain.NewUser(
			user.ID,
			user.Version,
			user.FullName,
			user.PhoneNumber,
		)
	}

	return userDomain
}
