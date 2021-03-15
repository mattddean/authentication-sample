import { useState, useCallback, useMemo } from "react";
import { UserContextData, User } from "../contexts/UserContext";
import axios, { AxiosResponse } from "axios";

// https://wanago.io/2020/09/28/react-context-api-hooks-typescript/

export const useUserContextValue = (): UserContextData => {
  const [user, setUser] = useState<User[]>([]);
  const [isLoading, setIsLoading] = useState(false);

  const fetchUser = useCallback(() => {
    setIsLoading(true);
    fetch("https://jsonplaceholder.typicode.com/posts")
      .then((response) => response.json())
      .then((fetchedPosts) => {
        setPosts(fetchedPosts);
      })
      .finally(() => {
        setIsLoading(false);
      });
  }, []);

  const login = useCallback((email, password) => {
    return axios
      .post(API_URL + "/login", { email, password })
      .then((response: AxiosResponse<any>) => {
        return response.data;
      });
  }, []);

  const register = useCallback((email, password, firstName, lastName) => {
    return axios
      .post(API_URL + "/register", { email, password, firstName, lastName })
      .then((response: AxiosResponse<any>) => {
        return response.data;
      });
  }, []);

  const logout = useCallback(() => {
    fetch();
  });

  const removePost = useCallback(
    (postId: number) => {
      setIsLoading(true);
      fetch(`https://jsonplaceholder.typicode.com/posts/${postId}`, {
        method: "DELETE",
      })
        .then(() => {
          const newPosts = [...posts];
          const removedPostIndex = newPosts.findIndex(
            (post) => post.id === postId
          );
          if (removedPostIndex > -1) {
            newPosts.splice(removedPostIndex, 1);
          }
          setPosts(newPosts);
        })
        .finally(() => {
          setIsLoading(false);
        });
    },
    [setPosts, posts]
  );

  return useMemo(
    () => ({
      user,
      isLoading,
      fetchUser,
      logout,
    }),
    [posts, isLoading, fetchPosts, removePost]
  );
};
