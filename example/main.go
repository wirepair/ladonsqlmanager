package main

import (
	"database/sql"
	"log"
	"os"

	stdlib "github.com/jackc/pgx/stdlib"
	"github.com/ory/ladon"
	"github.com/wirepair/ladonsqlmanager"
)

func main() {
	dbstring := os.Getenv("DB_STRING")
	if dbstring == "" {
		log.Fatalf("DB_STRING not set")
	}
	driverConfig := stdlib.DriverConfig{}
	stdlib.RegisterDriverConfig(&driverConfig)

	db, err := sql.Open("pgx", dbstring)
	if err != nil {
		log.Fatalf("error connecting to db: %s\n", err)
	}

	var policy = &ladon.DefaultPolicy{
		ID:          "2",
		Description: "description",
		Subjects:    []string{"user"},
		Effect:      ladon.AllowAccess,
		Resources:   []string{"article:1"},
		Actions:     []string{"create", "update"},
	}

	manager := ladonsqlmanager.New(db, "postgres")
	if err := manager.Init(); err != nil {
		log.Fatalf("error initalizing ladonsqlmanager: %s\n", err)
	}

	warden := &ladon.Ladon{
		Manager: manager,
	}

	if err := warden.Manager.Create(policy); err != nil {
		log.Fatalf("failed to create policy: %s\n", err)
	}
	r := &ladon.Request{
		Subject:  "user",
		Resource: "article:1",
		Action:   "create",
	}

	pols, err := warden.Manager.FindRequestCandidates(r)
	if err != nil {
		log.Fatalf("error getting policies: %s\n", err)
	}

	for _, pol := range pols {
		log.Printf("%#v\n", pol)
	}

	err = warden.IsAllowed(r)

	if err != nil {
		log.Fatalf("error should be allowed: %s\n", err)
	}

}
