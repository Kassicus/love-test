#!/bin/bash

# Love2D Examples Runner Script

echo "Love2D Examples Runner"
echo "====================="
echo ""
echo "Choose an option:"
echo "1. Run main game"
echo "2. Run particle example"
echo "3. Run physics example"
echo "4. Run Snake game"
echo "5. Run Pong game"
echo "6. Run Minesweeper game"
echo "7. Run Angry Birds game"
echo "8. Exit"
echo ""

read -p "Enter your choice (1-8): " choice

case $choice in
    1)
        echo "Running main game..."
        love .
        ;;
    2)
        echo "Running particle example..."
        love examples/particles
        ;;
    3)
        echo "Running physics example..."
        love examples/physics
        ;;
    4)
        echo "Running Snake game..."
        love examples/snake
        ;;
    5)
        echo "Running Pong game..."
        love examples/pong
        ;;
    6)
        echo "Running Minesweeper game..."
        love examples/minesweeper
        ;;
    7)
        echo "Running Angry Birds game..."
        love examples/angrybirds
        ;;
    8)
        echo "Goodbye!"
        exit 0
        ;;
    *)
        echo "Invalid choice. Please run the script again."
        exit 1
        ;;
esac 