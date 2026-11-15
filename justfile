# Use zsh explicitly for all recipes
set shell := ["zsh", "-uc"]

year := "2025" # Change to 2026 once December arrives
base_url := "https://adventofcode.com"

# List available recipes
default:
    @just --list

# Fetch puzzle input (usage: just get 1)
get day:
    @padd=$(printf "%02d" {{day}}); \
    mkdir -p "solutions/day$padd"; \
    if [ -f "solutions/day$padd/input.txt" ]; then \
        echo "Input for day {{day}} already exists."; \
    else \
        echo "Fetching input for {{year}} Day {{day}}..."; \
        curl -s --location \
            -H "Cookie: session=$AOC_SESSION" \
            "{{base_url}}/{{year}}/day/{{day}}/input" \
            -o "solutions/day$padd/input.txt"; \
        echo "Saved to solutions/day$padd/input.txt"; \
    fi

# Scaffold boilerplate (usage: just new 1)
new day: (get day)
    @padd=$(printf "%02d" {{day}}); \
    d="solutions/day$padd"; \
    if [ ! -f "$d/main.go" ]; then \
        echo "Creating boilerplate for Day {{day}}..."; \
        printf 'package main\n\nimport (\n\t"fmt"\n\t"os"\n\t"strings"\n)\n\nfunc main() {\n\tdata, _ := os.ReadFile("input.txt")\n\tinput := strings.TrimSpace(string(data))\n\t\n\tfmt.Println("Part 1:", part1(input))\n\tfmt.Println("Part 2:", part2(input))\n}\n\nfunc part1(input string) int {\n\treturn 0\n}\n\nfunc part2(input string) int {\n\treturn 0\n}\n' > "$d/main.go"; \
        touch "$d/sample.txt"; \
        echo "Boilerplate ready in $d/"; \
    else \
        echo "Boilerplate already exists for Day {{day}}."; \
    fi

# Run solution (usage: just run 1)
run day:
    @padd=$(printf "%02d" {{day}}); \
    echo "--- Running Day {{day}} ---"; \
    cd solutions/day$padd && go run main.go

# Run tests (usage: just test 1)
test day:
    @padd=$(printf "%02d" {{day}}); \
    cd solutions/day$padd && go test -v

# Run `go fmt` and `go vet` across the project
lint:
    @go fmt ./...
    @go vet ./...