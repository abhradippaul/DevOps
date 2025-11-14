import { useEffect, useState } from "preact/hooks";
import "./app.css";

interface Item {
  id: number;
  name: string;
}

// const BACKEND_URL = import.meta.env.VITE_BACKEND_URL;

export function App() {
  const [isBackendHealthy, setIsBackendHealthy] = useState(false);
  const [data, setData] = useState<Item[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  useEffect(() => {
    // fetch(BACKEND_URL)
    fetch("/api/")
      .then((res) => {
        if (!res.ok) {
          throw new Error("Failed to fetch data");
        }
        return res.json();
      })
      .then((data) => {
        console.log(data);
        setIsBackendHealthy(true);
      })
      .catch((err) => {
        setError(err.message);
      })
      .finally(() => {
        setLoading(false);
      });
  }, []);

  const handleButtonOnClick = () => {
    setLoading(true);
    setError(null);
    setData([]);

    // fetch(`${BACKEND_URL}/jokes`)
    fetch(`/api/jokes`)
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

  if (loading) return <p className="text-center text-lg">Loading...</p>;
  if (error) return <p className="text-red-500 text-center">Error: {error}</p>;

  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-gray-50 p-6">
      {isBackendHealthy ? (
        <h1 className="text-2xl font-bold mb-6">Fetch Data from Backend</h1>
      ) : (
        <h1 className="text-2xl font-bold mb-6">Backend is not healthy</h1>
      )}

      <button
        onClick={handleButtonOnClick}
        className="px-5 py-2 bg-blue-600 text-white rounded-lg shadow hover:bg-blue-700 transition"
        disabled={loading}
      >
        {loading ? "Loading..." : "Fetch Data"}
      </button>

      <div className="mt-6 w-full max-w-md">
        {error && (
          <p className="text-red-500 text-center mb-3">Error: {error}</p>
        )}

        {!error && Boolean(data.length) && (
          <ul className="space-y-2">
            {data.map((item) => (
              <li
                key={item.id}
                className="p-3 bg-white rounded-lg shadow-sm border hover:bg-gray-100"
              >
                {item.name}
              </li>
            ))}
          </ul>
        )}

        {!loading && !error && !Boolean(data.length) && (
          <p className="text-gray-500 text-center mt-4">
            No data fetched yet. Click the button above 👆
          </p>
        )}
      </div>
    </div>
  );
}
