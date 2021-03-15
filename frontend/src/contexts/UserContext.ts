import { createContext } from "react";

// https://wanago.io/2020/09/28/react-context-api-hooks-typescript/

export interface User {
  id: number;
  firstName: string;
  lastName: string;
  username: string;
  email: string;
}

export interface UserContextData {
  user?: User;
  isLoading: boolean;
  fetchUser: () => void;
  logout: () => void;
}

export const UserContext = createContext<UserContextData | undefined>(
  undefined
);
