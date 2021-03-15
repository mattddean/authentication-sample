import { useContext } from "react";
import { UserContext } from "../contexts/UserContext";

// https://wanago.io/2020/09/28/react-context-api-hooks-typescript/

export const useUserContext = () => {
  const postsContext = useContext(UserContext);
  if (!postsContext) {
    throw new Error(
      "useUserContext must be used within the UserContext.Provider"
    );
  }
  return postsContext;
};
