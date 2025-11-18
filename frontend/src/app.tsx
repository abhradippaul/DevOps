import { useEffect, useState } from "preact/hooks";

interface Item {
  id: number;
  name: string;
}

const BACKEND_URL = import.meta.env.VITE_BACKEND_URL || "";

export function App() {
  const [env, setEnv] = useState("DEV");
  const [data, setData] = useState<Item[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  useEffect(() => {
    fetch(`${BACKEND_URL}/api/`)
      .then((res) => {
        if (!res.ok) {
          throw new Error("Failed to fetch data");
        }
        return res.json();
      })
      .then((data) => {
        console.log(data);
        setEnv(data.env);
      })
      .catch((err) => {
        setError(err.message);
      })
      .finally(() => {
        setLoading(false);
      });
    console.log(BACKEND_URL);
  }, []);

  const handleButtonOnClick = () => {
    setLoading(true);
    setError(null);
    setData([]);

    fetch(`${BACKEND_URL}/api/jokes`)
      .then((res) => {
        if (!res.ok) {
          throw new Error("Failed to fetch data");
        }
        return res.json();
      })
      .then(({ msg, data }) => {
        console.log(msg);
        setData(data);
      })
      .catch((err) => {
        setError(err.message);
      })
      .finally(() => {
        setLoading(false);
      });
  };

  if (loading)
    return (
      <p className="text-center text-lg text-gray-300 animate-pulse">
        Loading...
      </p>
    );

  if (error)
    return (
      <div className="min-h-screen flex flex-col items-center justify-center bg-gray-900 p-6">
        <h1 className="text-3xl font-bold mb-4 text-red-400 drop-shadow">
          Backend is not healthy
        </h1>

        {error && (
          <p className="text-red-500 text-center bg-red-900/30 px-4 py-2 rounded-lg border border-red-700">
            Error: {error}
          </p>
        )}
      </div>
    );

  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-gray-900 p-6 text-gray-200">
      <div className="bg-gray-800/70 backdrop-blur-lg p-8 rounded-2xl shadow-xl border border-gray-700 w-full max-w-2xl">
        <h1 className="text-3xl font-extrabold mb-4 text-blue-400">
          Fetch Jokes from Backend
        </h1>
        <div className="flex items-center justify-between">
          <h2 className="text-xl font-semibold text-gray-300">
            Environment: {env.toUpperCase()}
          </h2>
          <h2>Error</h2>
          <button
            onClick={handleButtonOnClick}
            className="px-6 py-3 bg-blue-600 text-white rounded-lg shadow-lg border border-blue-700 hover:bg-blue-700 hover:scale-105 active:scale-95 transition-all duration-200"
            disabled={loading}
          >
            {loading ? "Loading..." : "Fetch Jokes"}
          </button>
        </div>

        <div className="mt-8 w-full">
          {error && (
            <p className="text-red-500 text-center mb-3 bg-red-900/30 px-4 py-2 rounded-lg border border-red-700">
              Error: {error}
            </p>
          )}

          {!error && Boolean(data.length) && (
            <ul className="space-y-3">
              {data.map((item) => (
                <li
                  key={item.id}
                  className="p-3 bg-gray-800 border border-gray-700 rounded-lg shadow-sm hover:bg-gray-700/70 hover:translate-x-1 transition-all"
                >
                  <span className="text-gray-300">{item.name}</span>
                </li>
              ))}
            </ul>
          )}

          {!loading && !error && !Boolean(data.length) && (
            <p className="text-gray-400 text-center mt-6">
              No data fetched yet. Click the button above
            </p>
          )}
        </div>
      </div>
    </div>
  );
}
