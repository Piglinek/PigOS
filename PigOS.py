import os
import hashlib

class UserManager:
    def __init__(self, filename='users.txt'):
        self.filename = filename
        # Create users file if it doesn't exist
        if not os.path.exists(self.filename):
            with open(self.filename, 'w') as f:
                pass
    
    def _hash_password(self, password):
        """Hash the password using SHA-256"""
        return hashlib.sha256(password.encode()).hexdigest()
    
    def register(self, username, password):
        """Register a new user"""
        # Check if username already exists
        with open(self.filename, 'r') as f:
            for line in f:
                if line.startswith(username + ':'):
                    return False, "Username already exists"
        
        # Add new user
        with open(self.filename, 'a') as f:
            hashed_pw = self._hash_password(password)
            f.write(f"{username}:{hashed_pw}\n")
        return True, "Registration successful"
    
    def login(self, username, password):
        """Login existing user"""
        hashed_pw = self._hash_password(password)
        with open(self.filename, 'r') as f:
            for line in f:
                stored_user, stored_pw = line.strip().split(':')
                if stored_user == username and stored_pw == hashed_pw:
                    return True, "Login successful"
        return False, "Invalid username or password"

def main():
    user_manager = UserManager()
    
    while True:
        print("\n1. Register")
        print("2. Login")
        print("3. Exit")
        
        choice = input("Choose an option: ")
        
        if choice == '1':
            username = input("Enter username: ")
            password = input("Enter password: ")
            success, message = user_manager.register(username, password)
            print(message)
            
        elif choice == '2':
            username = input("Enter username: ")
            password = input("Enter password: ")
            success, message = user_manager.login(username, password)
            print(message)
            if success:
                print(f"Welcome, {username}!")
                break
                
        elif choice == '3':
            print("Goodbye!")
            break
            
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    print("Welcome to the Login System")
    main()
