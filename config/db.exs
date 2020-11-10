use Amnesia

@doc """
Specifies the Heron database, for storing state during runs.
"""
defdatabase HeronData do
  deftable Projects

  deftable Project, [{ :path, :name, :src, :build], type: :ordered_set, index: [:id, :name] do
    @type t :: %Project{path: String.t, name: String.t, src: String.t, build: String.t}

    def add_project(self, name, path) do
      %Message{path: path, name: name, src: "src", build: "build"}
    end

    def set_src(self, src) do
      %Message{path: self.path, name: self.name, src: src, build: self.build}
    end

    def set_name(self, name) do
      %Message{path: self.path, name: name, src: self.src, build: self.build}
    end
  end
end
