# FCC - Voting

## Funtions
- Create Poll
- View My Poll
- New Option
- Vote/Delete-Vote Option
- Chart

## How to run:
- git clone https://github.com/pearl2201/ffc-voting
- cd ffc-voting && mix deps.get
- cd assets && npm install
- cd .. && mix.ecto.create && mix.ecto.migrate
- mix phx.server

## Tip:
- If you don't want to use fb app to login, you could try route /auth/hack/<id_user> after creating User with iex.