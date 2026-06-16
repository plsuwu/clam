#include <emscripten.h>
#include <print>
#include <raylib.h>

enum class State {
    Waiting,
    Ready,
    Running,
    Done,
};

class JamState {
  public:
    State state = State::Waiting;

    void log() const {
        static constexpr std::array names = {"WAITING", "READY", "RUNNING", "DONE"};
        std::println("[state] {}", names[static_cast<int>(state)]);
    }

    void advance() {
        if (state != State::Done) {
            state = static_cast<State>(static_cast<int>(state) + 1);
        }
    }
};

class Mergeable {
  public:
    virtual ~Mergeable() = default;
};

class Scene {};

int main() {
    const int screenW = 800;
    const int screenH = 450;

    InitWindow(screenW, screenH, "raylib");
    SetTargetFPS(60);

    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(RAYWHITE);

        DrawText("hello raylib", screenW / 2, screenH / 2, 28, BLACK);

        EndDrawing();
    }
}
